---
title: Durable Objects & SvelteKit - My Setup
description: |
  A talk through of my setup for using SvelteKit with Cloudflare Page Functions and
  Durable Objects.

tags:
- svelte
- sveltekit
- cloudflare
- cloudflare-pages
- cloudflare-durable-objects
---

{% include annotation-info.html %}

In my previous post I talked about hacking my way around getting Websockets to
Cloudflare Durable Objects working within SvelteKits routing setup. During that
post I mostly skipped over the setup of my project and how to handle some of
the current frictions between Durable Objects and Pages so I wanted to circle
back and talk about the setup I'm using to manage a SvelteKit project that also
has Durable Objects and what the automation of this setup looks like.

{: .callout.yellow }
<div markdown="1">
  This post was written against the following versions and the information may
  not be completely up to date in the future, given the beta nature of
  Page Functions and SvelteKit.

  - Node.JS version 18.4.0
  - NPM version 8.12.1
  - Wrangler version 2.0.14
  - SvelteKit version 1.0.0-next.350
</div>

Before I dive into _how_ to set things up the way I have, lets talk over the
general "what" and touch on why I took this approach and the problems I solved
for while doing so.

# The What and Whys

At the time of this post, Durable Objects cannot be defined and deployed from
a Page Functions project. To get around this, you make a Worker project that
contains dummy no-op worker and exports the Durable Objects.

One approach to work around this is to define that worker within your SvelteKit
project, such as at `src/dummy-worker.js`, and tell Wrangler to use that file
to keep all the code and configuration centralized. While this works for the
moment as `wrangler.toml` has no use for a Pages projects, I'm not a fan of
this setup.

Having the code all within the SvelteKit directory structure and project
conflates the fact that these are logistically two separate projects within
Cloudflare. The Worker has no knowledge of the Page Functions, and the Page
Functions/SvelteKit only know of the binding to the Workers' Durable Objects.
Additionally, while `wrangler.toml` is not used for Pages projects at the
moment, there isn't a guarantee that this will always be the case; For example, there
remains the possibility that Page Functions could gain the ability to expose
Durable Objects on their own which might mess with our setup and cause some
headaches.

While it is convenient to have all the code in a central place, I think this
pattern is not optimal, especially when the JS world has some rich monorepo
tooling. Consequentially, I've chosen to split up my codebase into a SvelteKit
project under `site/` and the Durable Objects project under `durable_objects/`.

Since I'm going to use a monorepo pattern, I looked around and decided to give
[npm workspaces](https://docs.npmjs.com/cli/v8/using-npm/workspaces) a go as it
brings an npm-builtin way to run commands across the whole monorepo or within a
specific workspace, as well as installing and managing packages across those
workspaces. The basic setup looks something like:

```
.
├── core
│   └── package.json
├── durable_objects
│   └── package.json
└── package.json
```

and `/package.json` looks a bit like:

```json
{
  "name": "top-secret-project",
  "workspaces": [
    "site",
    "durable_objects"
  ]
}
```

With each `site/package.json` and `durable_objects/package.json` having a
`name` that looks a bit like `@top-secret-project/site` and
`@top-secret-project/durable_objects` respectfully.

One issue that arises out of splitting the Durable Object and SvelteKit
projects is the high likelihood that the SvelteKit project is going
to be sharing TypeScript Types as well as utility code and data with the
Durable Objects. Thankfully this is quick and easy to work around by adding a
third package to our new monorepo. I chose to name this `core`, and just added
`"core"` to `package.json`'s `workspaces` key and set the `core/package.json`
name to `@top-secret-project/core`.

The neat thing about this setup is that now I can share TypeScript code and
types without any additional work and I can easily import `core` code from
anywhere in the SvelteKit or Durable Object projects with something like the
following:

```typescript
import { type Turtle, PetsEnum } from "@top-secret-project/core/lib/animals"
```

# The Hows

With the Whys and some of the problems we're going to address outlined, let's
actually build this setup out to see how things really work!

## Initial Setup

First we'll need our root directory for everything. Where ever works for you,
make a directory and navigate into it.

```bash
mkdir top-secret-project
cd top-secret-project
```

Before we start slinging `npm` commands around, we'll need a basic
`package.json` here in the root directory, throw something like this into
`package.json`. Don't worry about adding anything else, `npm` will take care of
everything else for us as we go.

```json
{ "name": "top-secret-project" }
```

Next, lets make our `core` workspace. This step will also automatically add a
`workspaces` key to your `/package.json` file with an array value of
`["core"]`, neat!

When it asks for a name, I like to use the root projects name prefixed with an
`@`, so my name for `core` will be `@top-secret-project/core`.

```bash
npm init -w core
```

Notice the `-w core` flag on the command. This is how you tell npm to operate
within the `core` workspace. If you had a workspace under `a/b/c/package.json`
for example, you'd instead use something like `-w a/b/c`.

You can repeat this for `durable_objects/` as well to scaffold out the basic
setup we'll expand upon later;

```bash
npm init -w durable_objects
```

Finally, lets get our SvelteKit project setup too:

```bash
npm init svelte site
```

I personally chose "TypeScript" and answer yes to all three: ESLint, Prettier
and Playwright, but you can go with whatever options are comfortable for you.
Unfortunately SvelteKit doesn't set up an npm workspace for us, so we'll have
to open `/package.json` and add `"site"` to the `workspaces` array. I also like
to add the `@top-secret-project/` prefix to the name in `site/package.json` for
consistency.

After this you should have something similar to the following directory setup:

```
.
├── core
│   └── package.json
├── durable_objects
│   └── package.json
├── package.json
└── site
    ├── README.md
    ├── package.json
    ├── playwright.config.ts
    ├── src
    ├── static
    ├── svelte.config.js
    ├── tests
    └── tsconfig.json
```

## The core Workspace

The `core` workspace is probably the easiest to get setup. I add a basic
`tsconfig.json` for TypeScript, add `typescript` as a dependency and throw some
basic code into `lib/`. While not super necessary, this does make it easier to
see what's happening and to expand or even publish this workspace as it's own
npm package later on in the future.

Let's add `typescript` as a dependency to see how this works with npm
workspaces. From the root directory you can run:

```bash
npm install typescript -w core
```

This runs just like a normal npm install, but it'll update the
`/core/package.json` file instead of our root `/package.json`.

Next, I add a basic `/core/tsconfig.json` just for clarity. This one aligns closely
with the current config that SvelteKit ships with, so I don't have much to
worry about in regards to differing styles between the projects. There's some
additional magic you could do with having a common file that's shared between
projects, but this setup works well for me and doesn't cause headaches at the
end of the day:

```json
{
  "compilerOptions": {
    "allowJs": true,
    "checkJs": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "skipLibCheck": true,
    "sourceMap": true,
    "strict": true,
    "importsNotUsedAsValues": "error",
    "isolatedModules": true,
    "preserveValueImports": true,
    "lib": [
      "esnext",
      "DOM"
    ],
    "moduleResolution": "node",
    "module": "esnext",
    "target": "esnext",
  },
  "include": [
    "./lib/**/*.js",
    "./lib/**/*.ts",
  ],
  "exclude": [
    "./node_modules/**",
  ]
}
```

Let us also add in a basic file so we can start playing with this code in the
other workspaces. In `/core/lib/index.ts` add the following:

```typescript
// /core/lib/index.ts
export function helloWorld(name: string): string {
  return `Hello, ${ name }!`
}
```


## The durable_objects Workspace

We've got a few small things to finish in the durable objects workspace. First,
we'll need to create a basic configuration for Wrangler:

```
cd durable_objects/ && npx wrangler init
```

I personally chose no for git (Since the git repo would be the root, not
inside of `durable_objects/`), yes for adding wrangler to `package.json` and
yes TypeScript and chose `Fetch handler` for the template to add to
`src/index.ts` just to get a file setup.

This command will also generate a `wrangler.toml` file for you, which we'll use in
just a minute to setup the Durable Objects in Cloudflare, with the `main` key
already set to the newly created `src/index.ts`. Next, we'll add a basic
Durable Object which will use our `core` `helloWorld()` function when called.

Add the following export to `/durable_objects/src/index.ts`:

```typescript
export { MyDO } from "./MyDO"
```

And create the file `/durable_objects/src/MyDO.ts` with the following:

```typescript
import { helloWorld } from "@top-secret-project/core/lib"

interface Env {}

export class MyDO {
  constructor(public state: DurableObjectState, public env: Env) {}

  async fetch(request: Request) {
    const { name } = await request.json()

    return new Response(helloWorld(name), { status: 200 })
  }
}
```

We'll be able to make a request to this Durable Object with a JSON encoded body
containing a `name` key and get back a plain text response with the result of
our `helloWorld()` function from `core`.

The last piece of the puzzle for this workspace is to tell Wrangler about the
Durable Object. We do this via adding a few bits of configuration to the
`wrangler.toml` file which tells Cloudflare to create a new Durable Object for
us named `MyDO` using the `MyDO` class which is exported by
`/durable_objects/src/index.ts`:

{% source toml hl_lines="5 6 7 8 9 10 11 12" %}
name = "durable_objects"
main = "src/index.ts"
compatibility_date = "2022-06-18"

[durable_objects]
bindings = [
  { name = "MyDO", class_name = "MyDO" }
]

[[migrations]]
tag = "v1"
new_classes = ["MyDO"]
{% endsource %}

## The site Workspace

There isn't actually a ton to do here to get going, however, I typically set up
some basic helpers and hooks to make life in Cloudflare Page Functions a little
easier. We'll add in support for some Cloudflare specific functionality such as
bindings and their TypeScript Types, as well as error handling through Sentry
and finally we'll hook up an endpoint to call our Durable Object that we setup
above.

#### Adaptor Setup

One thing we should take care of is setting up the adaptor. We don't have to
install anything as the [Cloudflare
adaptor](https://github.com/sveltejs/kit/tree/master/packages/adapter-cloudflare#environment-variables)
is already installed with `@sveltejs/adapter-auto` so we just need to adjust
`site/svelte.config.js` by adding the import for the cloudflare adaptor:

{% source javascript hl_lines="1 11" %}
import adapter from "@sveltejs/adapter-cloudflare"
import preprocess from "svelte-preprocess"

/** @type {import('@sveltejs/kit').Config} */
const config = {
  // Consult https://github.com/sveltejs/svelte-preprocess
  // for more information about preprocessors
  preprocess: preprocess(),

  kit: {
    adapter: adapter(),
    prerender: {
      enabled: false,
    },
  },
}

export default config
{% endsource %}

#### Cloudflare Types

We'll also want to add the Cloudflare specific types and type the
[`platform`](https://github.com/sveltejs/kit/tree/master/packages/adapter-cloudflare#environment-variables)
variable that is available inside of endpoints. This includes an `env` key
that'll be used for bindings, and a `context` key, and we'll use the Cloudflare
worker types in a bit for our Durable Object bindings.

The `context` isn't a ton of use in our SvelteKit project, but it does include
a function that you should be aware of, `waitUntil()`. You can read more about
when you'd want this `context.waitUntil()`
[here](https://developers.cloudflare.com/workers/runtime-apis/fetch-event/#waituntil).

```bash
npm install @cloudflare/workers-types -w site
```

In `site/src/app.d.ts`, lets add our reference to the Cloudflare types for the  and expand the interface for `App.Platform` to include this:

{% source typescript hl_lines="2 7 8 9 10 11 12" %}
/// <reference types="@sveltejs/kit" />
/// <reference types="@cloudflare/workers-types" />

// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
declare namespace App {
  interface Platform {
    env: {};
    context: {
      waitUntil(promise: Promise<unknown>): void;
    };
  }
}
{% endsource %}

#### Error Handling

I like to use [Sentry](https://sentry.io/) for error tracking. Inside of
Workers, it's recommended to use
[`toucan.js`](https://github.com/robertcepa/toucan-js) due to how the worker
environment works. To tie this in with SvelteKit we'll need to add a
[hook](https://kit.svelte.dev/docs/hooks#handle) that wraps requests and
reports any errors to sentry through Toucan:

```bash
npm install toucan-js -w site
```

And add the following handler to your `site/src/hooks.ts` file:

```typescript
// /site/src/hooks.ts
import type { Handle } from '@sveltejs/kit';
import { sequence } from '@sveltejs/kit/hooks';
import Toucan from 'toucan-js';

/** @type {import("@sveltejs/kit").Handle} */
const sentry: Handle = async ({ event, resolve }) => {
  if (import.meta.env.DEV) return await resolve(event);

  const {
    request,
    platform: { context }
  } = event;

  const YOUR_DSN = "putsomethinghereplz"

  const sentry = new Toucan({
    dsn: YOUR_DSN,
    context,
    request,
    allowedHeaders: ['user-agent'],
    allowedSearchParams: /(.*)/
  });

  try {
    return await resolve(event);
  } catch (e) {
    sentry.captureException(e);
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return new Response((e as any).reason, { status: 500 });
  }
};

export const handle = sequence(sentry);
```

You can use any number of methods for getting the DSN into your project.
Setting `YOUR_DSN` to `import.meta.env.VITE_SENTRY_DSN` might be one option,
letting it get set during the build phase, or you might want to use an
environment variable binding in Cloudflare and instead pull it out of
`platform.env`. Let's use the latter as it allows us to set a different DSN for
preview and production environments in Cloudflare Pages.

We'll need to add the binding to our types:

{% source typescript hl_lines="9" %}
/// <reference types="@sveltejs/kit" />
/// <reference types="@cloudflare/workers-types" />

// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
declare namespace App {
  interface Platform {
    env: {
      SENTRY_DSN: string
    };
    context: {
      waitUntil(promise: Promise<unknown>): void;
    };
  }
}
{% endsource %}

And then change our hook a little to pull it out:

{% source typescript hl_lines="6 9" %}
const sentry: Handle = async ({ event, resolve }) => {
  if (import.meta.env.DEV) return await resolve(event);

  const {
    request,
    platform: { context, env }
  } = event;

  const YOUR_DSN = env.SENTRY_DSN;

  const sentry = new Toucan({
    dsn: YOUR_DSN,
    context,
    request,
    allowedHeaders: ['user-agent'],
    allowedSearchParams: /(.*)/
  });

  try {
    return await resolve(event);
  } catch (e) {
    sentry.captureException(e);
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return new Response((e as any).reason, { status: 500 });
  }
};
{% endsource %}

#### Calling our Durable Object

Now that we've got the basics all out of the way, we can hook up our Durable
Object and call it from an endpoint!

First we'll need to expand our `App.Platform.env` interface once more. I'm
going to setup my binding as `MyDO` so we'll access the Durable Objects stub
through `platform.env.MyDO` inside of an endpoint:

{% source typescript hl_lines="10" %}
/// <reference types="@sveltejs/kit" />
/// <reference types="@cloudflare/workers-types" />

// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
declare namespace App {
  interface Platform {
    env: {
      SENTRY_DSN: string;
      MyDO: DurableObjectNamespace;
    };
    context: {
      waitUntil(promise: Promise<unknown>): void;
    };
  }
}
{% endsource %}

Next up we'll add a basic endpoint and page to call the DO from the server side
and display our response, using a name passed in via a query string parameter:

```typescript
// site/src/routes/index.ts
import type { RequestHandler } from './__types/index.d';

export const get: RequestHandler = async ({ url, platform }) => {
  const name = url.searchParams.get('name');

  const doId = platform.env.MyDO.idFromName('greeting');
  const doStub = platform.env.MyDO.get(doId);

  const doResponse = await doStub
    .fetch('/dummy', {
      body: JSON.stringify({
        name
      })
    })
    .then((res) => res.text());

  return {
    body: {
      doResponse
    }
  };
};
```

```html
<script lang="ts">
  export let doReponse: string;
</script>

<svelte:head>
  <title>Home</title>
</svelte:head>

Our DO Says: {doReponse}
```

Let's break the endpoint down a little bit.

## Cloudflare Configuration & Automations



## Final Thoughts
