---
title: Project - Raton
permalink: "/projects/raton"
---

<div class="not-prose mb-2">
  <div class="relative group">
    {% include figure.html src="/assets/projects/raton/cover.png" alt="Raton cover image" caption='Icon: <a href="https://thenounproject.com/icon/mountains-542371/">Mountains by TS Graphics from NounProject.com</a>' %}

    <div class="mt-4 flex items-center justify-between text-base font-medium space-x-8">
      <h3>Raton</h3>

      <!--<div class="flex items-center space-x-4">-->
        <!--<a href="#" class="w-48">-->
          <!--<img src="/assets/projects/chrome-get-the-addon.png" />-->
        <!--</a>-->
        <!--<a href="#" class="w-48">-->
          <!--<img src="/assets/projects/amo-get-the-addon.png" />-->
        <!--</a>-->
      <!--</div>-->
    </div>

    <span class="tag">Browser Extension</span>
  </div>
</div>

**TL;DR** Raton is a minimal RSS feed reader designed to let you read the feeds
and get out of your way, packaged as a browser extension.

RSS *never really* died, for most sites it just slipped into the background but
is still used. I couldn't find a small and lightweight reader that sat well
with me and just got out of the way so, naturally, the only solution was to write
my own.

## Screenshots
![](/assets/projects/raton/feeds.png)
![](/assets/projects/raton/feed-management.png)
![](/assets/projects/raton/settings.png)

## Technology
- Svelte, Typescript, Tailwind CSS all bundled together with Rollup.js
- Stores feeds in IndexDB, leaning on Dexie.js for a nicer interface
- Home-rolled feed parser library using the browsers built in DOM and JSON API's

## Neat Details
- Raton's keyboard binding system makes use of a Trie (aka a Prefix Tree) for
  fast but configurable and sequenced keyboard shortcuts.
