---
title: Browser Extension with Rollup - Svelte & Settings

tags:
- browser-extension
- rollupjs
- typescript
- svelte
---

<em>
This post contains inline annotations/footnotes to help add context, helpful tips or expand upon a tangent in the text. Expand them by {% aside clicking or tapping on them %}
Annotations might have their own {% aside annotations | red %}
Such as this one!
{% endaside %} inside of them too.
{% endaside %}

In the [previous post](/2021/10/22/browser-extensions-with-rollup-omnibox-chatter.html), we set up TypeScript, and started to tie into the browser's "Omnibox," which let's the browser give our extension the users input into the URL bar. Today we'll finish up the last bit of ground work, installing Svelte and using it to build the basis of a settings page for our extension; We'll add a new entry to our Rollup, install and configure Svelte and get "web-accessible" resources into our extension.

As a reminder of what we're building through this series: A simple browser extension that allows for the creation of "aliases" via the URL bar, e.g., if the browser extension registers `goto` as the keyword, the user could set up the alias `github/me` to go to their GitHub profile and type in `goto github/me` to the URL bar to make use of the alias; Something similar to [Redirector](https://github.com/einaregilsson/Redirector).

Along the way, we'll cover an introduction to browser extensions, talk about making them function under both Chrome and Firefox with minimal changes and how to use tools like Rollup.js to help bundle one.

{: .callout.blue}
While I'm writing these posts using my own preferences on techniques and technologies (which include Rollup.js as well as [TypeScript](https://www.typescriptlang.org/), [Svelte](https://svelte.dev/)), there are a lot of alternative approaches, and it's the concepts that are the core take away. Nothing precludes you from using different technologies; if you'd like to follow along using Vanilla ES6+ and [esbuild](https://esbuild.github.io/), or any other number of setups, {% aside go right ahead! | purple %}
For example, I've been meaning to mess around with [Solid.js](https://www.solidjs.com/) or [Rescript w/ React](https://rescript-lang.org/). Maybe even replace Rollup.js with esbuild or [swc](https://swc.rs/). All of which shouldn't be too difficult to adapt this series for.
{% endaside %}
