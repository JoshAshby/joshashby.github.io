---
title: SvelteKit & Cloudflare Durable Object Websockets
tags:
- svelte
- cloudflare
- cloudflare-pages
- cloudflare-durable-objects
- sveltekit
---

I'm always eyeing light-weight setups to build out little personal tools that let me have a combo of static or Svelte based frontends and little server side APIs for persistence and the likes. Historically this took the shape of Ruby/Roda/SQLite backends with a Vite.js/Svelte frontend setup, but recently I decided to give SvelteKit a go since it checks all the boxes and requires minimal setup. I still need somewhere to painlessly host these SvelteKit based projects as I don't feel like spinning up a VPS and my go to static host, GitHub Pages, doesn't allow me to run a small back-end server. Cloudflare's been making some big splashes in this area as of late, however, so I decided to give them a go and see what's what with thier Worker and Pages platforms.

Today, I'll just be focusing on some friction I hit when trying to use a websocket to a Cloudflare Durable Object from within a SvelteKit Endpoint hosted with Cloudflare Page Functions, and my exploration of a crude solution to keep the ergonomics of Endpoints while accomplishing my goal of establishing this websocket connection.
### Intros
Pages are Cloudflares static hosting solution that entered General Availablility in April of 2021, and back in November of 2021 they announced a new feature to Pages called ["Functions"](https://blog.cloudflare.com/cloudflare-pages-goes-full-stack/) which are slightly specialized versions of {% aside Cloudflare Workers %}Cloudflare Workers being their stateless, "serverless" solution, running your code on a per-request basis in an isolated V8 environment.{% endaside %} that can be deployed alongside your Pages project to provide a full API or even do server side rendering or other tasks. While Page Functions are in [beta still](https://developers.cloudflare.com/pages/platform/functions/), they're already powerful and fun to play with and open a ton of doors for progressively enhancing existing static sites with more dynamic and server side functionality, due to Pages' support for easily publishing existing frameworks such as my beloved Jekyll.

While Page Functions, like the Workers they use behind the scenes, are stateless, Cloudflare has also released into General Availability a feature to Workers that they call ["Durable Objects"](https://blog.cloudflare.com/durable-objects-ga/). Durable Objects are essentially another form of specialized Workers that have disk and cache backed storage for persistence and aim to help solve issues around state keeping in the distributed environment that Worker's run in.

Finally, SvelteKit is the official Svelte based setup for building static, server side rendered, and single page applications. It's similar in concept to Next.js/Nuxt.js but using Svelte instead. SvelteKit has two parts: the Svelte stuff, which can be server side rendered, or prerendered into a static site, and server side ["Endpoints"](https://kit.svelte.dev/docs/routing#endpoints) which write and route very similar to Page Functions and give you the ability to fairly painlessly build out APIs and other back-end functionality that ties in with the rest of your Svelte project seamlessly. The other neat thing about SvelteKit is that it already has an "adaptor" to build and deploy to Cloudflare Pages, including the ability to convert it's endpoints into Page Functions!

### And the WebSockets?
One neat thing with Durable Objects is that a single instance can hold onto multiple websocket connections, a feature that the demonstrate with their [chat demo](https://github.com/cloudflare/workers-chat-demo):

```typescript
// Our DurableObject
export class Room {
  sockets: WebSocket[] = []

  constructor(public state: DurableObjectState, public env: Env) {}

  async fetch(request) {
    const pair = new WebSocketPair()
		pair[1].accept()
		
    this.sockets = [...this.sockets, pair[1]]
		
    pair[1].onMessage(({ data }) => console.log(data))

    this.sockets.forEach(socket => {
      socket.send("new connection!")
    })

    return new Response(null, { status: 101, webSocket: pair[0] })
  }
}
```

To use this feature from a regular Worker, you pretty much just pass through the request from the client to the Durable Object. Since Page Functions are just Workers wrapped with a little more structure, we can use the same concept for them in our Pages project just within a `onRequestXYZ` handler:

```typescript
// functions/api/rooms/[id]/[[restUrl]].ts
export async function onRequestGet({ request, env }) {
  let url = new URL(request.url)

  const id = env.rooms.idFromName(name)
  const roomObject = env.rooms.get(id)

  return roomObject.fetch(url.pathname, request)
}
```

Obviously you'd want to put in some path handling, validation and error handling and removing dead connections from `sockets` to both sides, but this is the general approach for setting up this feature and getting multiple clients all coordinating through websockets. While nothing new and groundbreaking, this is by far the easiest and lowest entry barrier into a setup like this, and I've been pretty happy with the developer experience even with all the rough edges a lot of this still has in Cloudflare.

### SvelteKit
SvelteKit endpoints look and write pretty similar to Page Functions, and as stated above they can be deployed to Cloudflare Page Functions with ease. Unfortunately, I'm new to using SvelteKit (and it's pre-1.0 still so stuff is in flux just like with half of the Cloudflare features we're using here already) so I had a bit of a learning experience to figure out how to ~best work with~ hack around with stuff to get DO's inside of SvelteKit endpoints working.

Let’s take a stab at converting the above Page Function into an endpoint:

```typescript
// src/routes/api/rooms/[id]/[...restUrl].ts
import type { RequestHandler } from "./[...restUrl].d"

export const get: RequestHandler = async ({
  params,
  platform,
  request,
}) => {
  const roomId = platform.env.rooms.idFromName(params.id)
  const room = platform.env.rooms.get(roomId)

  if (!room) return { status: 404 }

  return room.fetch(params.restUrl, request)
}
```

Unsurprisingly, it looks pretty dang similar, but it doesn't work. The first problem is that Endpoints don't return a `Response` object, like Page Functions do; instead they have a simplified type of `{ status, headers, body }` which you can return. This is a bit of a problem, because as you might have guessed already, `room.fetch()` is returning a `Response` object. Let’s try and change our endpoint to account for this difference and see where it gets us:

```typescript
  const res = await room.fetch(params.restUrl, request)

  return {
    status: res.status,
    headers: res.headers,
    body: res.body,
  }
```

This works for non-websocket requests, but as soon as you try to open a websocket to the DO you hit this fun error:

```
RangeError: Responses may only be constructed with status codes in the range 200 to 599, inclusive.
```

Wut. I get that frameworks like SvelteKit try to make things easier but come on, HTTP is a lot more flexible than 200..599 status codes and the classic GET/POST/PUT/PATCH/DELETE/HEAD methods. Anyways.

Let's take a step back for a second and poke around the SvelteKit docs. In here, we'll find this little thing called ["Hooks"](https://kit.svelte.dev/docs/hooks#handle) and specifically, the `handle` hook. This is a function that takes in a `Request` and is expected to return a `Response` object and is called for nearly every request that hits the server. Ah-HA! Just what we need, the ability to return a `Response` object directly. Let's make a hook that does this:

```typescript
// src/hooks.ts
import type { Handle } from "@sveltejs/kit"

export const handle: Handle = async ({ event, resolve }) => {
  const {
    request,
    url: { pathname },
    params,
    platform,
  } = event

  if (pathname.endsWith("/websocket")) {
    const roomId = platform.env.rooms.idFromName(params.id)
    const room = platform.env.rooms.get(roomId)

    if (!room) return new Response("Not found", { status: 404 })

    return room.fetch(params.restUrl, request)
  }

  return resolve(event)
}
```

This is a dirty and naive attempt, we're just expecting the url to end with `/websocket` and that there is a `params.id` and `params.restUrl` if we're going to return the raw response from the DO. But sure enough, it'll work! I'd clean this up and add better checks to ensure that we're on the right route before attempting to interact with the DO, but the principle is there.

### On Ergonomics
So we've got our SvelteKit app, hosted on Cloudflare Pages and using Page Functions for the SvelteKit endpoints, responding to a websocket request and passing it through to our Durable Object which'll do all the heavy lifting to coordinate all connected clients. But it's using a naive, inflexible and not really ergonomic solution right now. For starters, it misses out on the routing that our endpoint gave us, so we have to do a bunch of path checking ourselves to make sure that we're handling the correct request. It also disconnects the logic from the rest of the relevant code, as it lives in `src/hooks.ts` whereas our other logic for talking with these DO is located in the `src/routes/api/rooms/` directory.

This is where my dirty, no good, hack solution comes in. I wanted to be able to use and return the `room.fetch()` calls directly from my endpoints rather than having to stuff them under a hook. The best way to do this, so far as I can tell right now, is to stuff things into [`locals`](https://kit.svelte.dev/docs/types#app-locals) from the request event that endpoints receive, and having a hook that'll return a response that is stuffed into there. It's **not ideal** and I would not recommend this for any production app, but it does work. Let’s take a look at the hook for this:

```typescript
// src/hooks.ts
import type { Handle } from "@sveltejs/kit"

export const handle: Handle = async ({ event, resolve }) => {
  const { locals } = event

  const res = await resolve(event)
  if (locals.wsResponse) return locals.wsResponse
  return res
}
```

And how it's used within the endpoint:

```typescript
// src/routes/api/rooms/[id]/[...restUrl].ts
import type { RequestHandler } from "./[...restUrl].d"

export const get: RequestHandler = async ({
  params,
  platform,
  request,
  locals,
}) => {
  const roomId = platform.env.rooms.idFromName(params.id)
  const room = platform.env.rooms.get(roomId)

  if (!room) return { status: 404 }

  const res = await room.fetch(params.restUrl, request)

  // Hack to allow this endpoint to handle websockets from the DO
  // The hook will return the contents of local.wsResponse
  // if present since endpoints can't return a Response object and
  // can't return status codes under 200 (or over 599).
  if (res.status === 101) {
    locals.wsResponse = res
    return { status: 200 }
  }

  return {
    status: res.status,
    headers: res.headers,
    body: res.body,
  }
}
```

Told you it was a hack. But it does work, helps keep the logic all contained in one spot and gives us the ergonomics of endpoints with only a minor inconvenience. It'd probably take this further and bundle it up into a little helper function to hide the implementation details and to help avoid abuse, but the general principle would be the same.

After getting this figured out, things have been pretty smooth sailing overall. I hope that SvelteKit gains the ability to return a raw Reponse from an endpoint in the future, or at least enough support to allow one to [handle websockets](https://github.com/sveltejs/kit/issues/1491) a little better so that this hack isn't necessary. I also wish Durable Objects were creatable from Pages' projects, or on their own without needing a {% aside no-op Worker %}I'll try to write about this experience on a later date once I've gotten some more experience with this setup.{% endaside %}, as currently I've got a separate setup to publish the DO's that my SvelteKit project is using. This separate setup even has it's own deploy step that isn't handled by the Pages deploy. Additionally, I hope that Page Functions get logging _soon_ and that they stop requiring Git integration to get Page Functions uploaded, but for a beta they're pretty powerful already and I'm excited to build some tools on top of this setup.
