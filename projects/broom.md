---
title: Project - Broom
permalink: "/projects/broom"
---

<div class="not-prose mb-2">
  <div class="relative group">
    <div class="overflow-hidden bg-gray-100">
      <img src="/assets/projects/broom/cover.png" alt="Broom cover image" class="object-center object-cover">
      <span class="font-mono text-xs text-gray-500 px-2">Icon: <a href="https://thenounproject.com/icon/broom-302960/">Broom by Francesco Cesqo Stefanini from NounProject.com</a></span>
    </div>

    <div class="mt-4 flex items-center justify-between text-base font-medium text-gray-900 space-x-8">
      <h3>Broom</h3>

      <div class="flex items-center space-x-4">
        <!--<a href="#" class="w-48">-->
          <!--<img src="/assets/projects/chrome-get-the-addon.png" />-->
        <!--</a>-->

        <a href="https://addons.mozilla.org/en-US/firefox/addon/broom/" class="w-48">
          <img src="/assets/projects/amo-get-the-addon.png" />
        </a>
      </div>
    </div>

    <span class="tag">Browser Extension</span>
  </div>
</div>

**TL;DR** Broom is a paid ($15 USD) browser extension for Firefox <!--and Chrome--> that lets
you scrape data from a web page up into a CSV or JSON file.

Looking to buy a license key for Broom?
<script src="https://gumroad.com/js/gumroad.js"></script>
<a class="gumroad-button" href="https://slothby.gumroad.com/l/broom">Buy on</a>

Broom was born out of the desire to quickly assemble data from sites that do not
expose an API into a spreadsheet, without wanting to spend time setting up a
full scraper for short one time tasks.

When activated by a button it places in the browsers toolbar, it provides a
visual click based interface to set up the configuration, make it aware of
pagination links and then lets you scrape the number of pages that you desire.
When finally done, it'll provide the choice of a CSV, JSON and a "Columnar
JSON" format download.

<!--## Screenshots-->
![](/assets/projects/broom/toolbar.png)
![](/assets/projects/broom/toolbar-granularity.png)
![](/assets/projects/broom/toolbar-error.png)
![](/assets/projects/broom/saving.png)
![](/assets/projects/broom/settings-1.png)
![](/assets/projects/broom/settings-2.png)
![](/assets/projects/broom/settings-3.png)

## Technology
- Svelte, Typescript, Tailwind CSS all bundled together with Rollup.js

## Neat Details
- Broom has my best library approach to RPC inside of web extensions yet, I'm
  pretty proud of it as it's typesafe, looks like a native promise call and
  supports a variety of uses from fire-and-forget to notify-everything
- Broom uses Svelte integration with Web Components to inject it's UI into a
  webpage in a isolated fashion, a nice upgrade from the iframe setup
  I've used in previous extensions
