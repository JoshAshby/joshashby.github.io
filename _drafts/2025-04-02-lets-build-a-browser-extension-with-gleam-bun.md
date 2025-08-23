---
title: "Let's build: A browser extension with Gleam & Bun!"
tags:
- browser-extension
- bun
- gleam
- lustre
- tailwind
---

I like to play around with new (to me at least) tech. Recently, I came across
[Gleam](#todo) and wanted to find a project to use it on. And then I saw that
[Bun](#todo) added a Svelte plugin and wanted to find a project to use Bun on
too. Things quickly snowballed and I've now got a browser extension that uses
Bun for bundling, Gleam, with Lustre forthe UI and Tailwind. Along the way I
had to create three separate plugins for Bun, as well as discovering some dark
corners full of bugs within FireFox's browser extension support.

<!-- more -->

## What We're Building

{:.callout.purple}
We are **not** going to be building a production ready setup. Today is all
about exploration, discovery and generally having fun while expanding our own
horizons and learning!

A useless little [browser extension](#todo) (for FireFox specifically[^1]) that
is bundled/built using Bun and programmed in Gleam. We'll use Lustre for the UI
and style it using Tailwind. Along the way, we'll build a few Bun bundler
plugins, discover a number of bugs within FireFox and run into friction with
the CSS spec.

[^1] - Although we're only concerning ourselves with FireFox for this, the
priciples are applicable to Chome/Edge/etc and shouldn't be hard to adapt.

The extension will have a small background script, and a content script which
gives us a good exploration of two common contexts that Web Extensions tend to
run in: contexts that are isolated and heavily interacting with callbacks/async
APIs and less isolated but more locked down contexts that are also more UI
focused.

We'll start off with getting a basic Gleam project setup. After that, we'll
layer in Bun and start integrating Gleam via a Bun bundler plugin. After that
we'll start on the actual Web Extension portion, building a small plugin for
Buns bundler to read a `manifest.json` to resolve which files to bundle.
Finally we'll start building a small UI with Lustre, which will inject into a
web page via a content script, and we'll try to use Tailwind to style that UI
in an isolated Shadow DOM.

All of this will be bundled together by Bun, which we'll point at a Web
Extension `manifest.json` file to resolve which files to actually bundle
together. This'll require a small Bun bundler plugin. We'll have another plugin
for interfacing with Gleam, to transpile the Gleam code to JavaScript. We'll
also have a third plugin for Tailwind.

## The Tools
- [Bun](#todo) is a newer-to-the-block JavaScript runtime, AND bundler. We'll be
  using the bundler side of things for this project.
- [Gleam](#todo) is an ML inspired language that runs on the BEAM VM, the same VM
  supporting Erlang and Elixir. Gleam also has a JavaScript target however,
  which is what we'll use today, allowing you to write Gleam that gets
  transpiled into JavaScript.
- [Lustre](#todo) is an Elm-inspired UI library for the Gleam JavaScript target.
- [Tailwind CSS](#todo) is a popular "utility class" based CSS framework.
- [Mise](#todo) which isn't a requirement but I'll be using to manage
  Gleam/Erlang/Rebar, and Bun.

## Let's Build!

First things first, we need to get some runtimes and dependencies installed.
We're going to start with getting Gleam set up first.

### Gleam Setup
- mise add gleam rebar
- gleam new
- configure for JS target
- gleam build
- explore build/ for the output js

### Bun as a Bundler
- mise add bun
- building a bun plugin to build gleam

### Bun-dling the Browser Extension
- building a bun plugin to build from a manifest.json

### A Small Step for Gleamkins
- make a background script with gleam

### Second Lustre Sparkle to the Right
- gleam add lustre
- try to use web-components
    - find out that lustre uses features that firefox doesn't support within
      it's browser extension for Shadow Dom (`adoptedStyleSheets`)
    - how do we work around this? don't use web-components but use shadow dom
      still. use a small ts/js wrapper script to make life easier and "avoid"
      some typing issues with gleam
    - lets us easily pull in the polyfill too since this ts is our entry point
    - totally not 100% necessary though, we could do this all through gleam in
      theory, I'm just lazy

### The Wind on our Tails
- setup tailwind
- use a custom layer setup to get host rules first
- write a custom bun plugin for running tailwind

### Fin
- make an options page rendered with lustre
- make a content script to add a tailwind styled button to the webpage with
  lustre

## Next Steps
- writing gleam ffi's for the browser web ext apis

## Reflection

That was fun, and unexpected in a lot of ways! I'm pretty disapointed in the
continued state of neglect that the Web Extension support within FireFox seems
to have[^2]. I'd love to see better attention paid to making it easier for an
extension to inject elements into the page while maintaining isolation and the
broken functionality of the Shadow DOM's `adoptedStyleSheets` in FireFox stands
as yet another impediment to this. I've mused about [other approaches](#todo)
that the Web Extension API could expose for content script like functionality
to accomplish this and would still love to see something like this feature in
the future.

I enjoyed Gleam and Lustre, although I'll admit that there are some language
features that are missing which sometimes makes the language feel a little
anemic. I know from my own language implementations that this is a fine line to
walk though.

Bun did great as a bundler, but I'd love to see some more inovation within it's
bundler plugin API. It closely follows the Vite (and I'm sure other bundler)
plugin API but it's different enough that plugins are not compatible. Instead
of following this, perhaps better support for patterns that require modifying
the builder config and could be explored without making it feel like you're
mutating global state.

[^2] - I think I have some authority to speak here, as I've got a number of
browser extensions that I've built, sold and support over the years.
