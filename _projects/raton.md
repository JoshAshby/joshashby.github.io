---
showcase: 2
title: Raton
logo_credit: "[Mountains by TS Graphics from NounProject.com](https://thenounproject.com/icon/mountains-542371/)"
cover:
  url: /assets/projects/raton/cover.png
  description: Raton is a minimal RSS feed reader designed to let you read the feeds and get out of your way, packaged as a browser extension.
tags:
  - Browser Extension
links:
  - url: https://slothby.club/raton
    content: Product Page
---

{: .callout }
Raton is currently in a private beta state and not quite ready for public release.

RSS *never really* died, for most sites it just slipped into the background but
is still used. I couldn't find a small and lightweight reader that sat well
with me and just got out of the way so, naturally, the only solution was to write
my own.

## Screenshots
{% include figure.html src="/assets/projects/raton/feeds.png" caption="" %}
{% include figure.html src="/assets/projects/raton/feed-management.png" caption="" %}
{% include figure.html src="/assets/projects/raton/settings.png" caption="" %}

## Technology
- Svelte, Typescript, Tailwind CSS all bundled together with Rollup.js
- Stores feeds in IndexDB, leaning on Dexie.js for a nicer interface
- Home-rolled feed parser library using the browsers built in DOM and JSON API's

## Neat Details
- Raton's keyboard binding system makes use of a Trie (aka a Prefix Tree) for
  fast but configurable and sequenced keyboard shortcuts.
