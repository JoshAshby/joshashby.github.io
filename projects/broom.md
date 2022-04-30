---
title: Project - Broom
permalink: "/projects/broom"
---

<div class="not-prose mb-2">
  <div class="relative group">
    {% include figure.html src="/assets/projects/broom/cover.png" alt="Broom cover image" caption='Icon: <a href="https://thenounproject.com/icon/broom-302960/">Broom by Francesco Cesqo Stefanini from NounProject.com</a>' %}

    <div class="mt-4 flex items-center justify-between text-base font-medium space-x-8">
      <a href="https://slothby.club/broom">
        <h3>Broom</h3>
      </a>

      <div class="flex items-center space-x-4">

        <a href="https://addons.mozilla.org/firefox/addon/broom/" class="w-48">
          <img src="/assets/projects/amo-get-the-addon.png" />
        </a>

        <a href="https://chrome.google.com/webstore/detail/depenoidancfjabbninhgimioodfgpdm" class="w-48">
          <img src="/assets/projects/chrome-get-the-addon.png" />
        </a>
      </div>
    </div>

    <span class="tag">Browser Extension</span>
  </div>
</div>

**TL;DR** Broom is a paid ($15 USD) browser extension for Firefox and Chrome that lets
you scrape data from a web page up into a CSV or JSON file.

Looking to buy a license key for Broom?
Check out it's <a href="https://slothby.club/broom">product page for more info.</a>

Broom was born out of the desire to quickly assemble data from sites that do not
expose an API into a spreadsheet, without wanting to spend time setting up a
full scraper for short one time tasks.

When activated by a button it places in the browsers toolbar, it provides a
visual click based interface to set up the configuration, make it aware of
pagination links and then lets you scrape the number of pages that you desire.
When finally done, it'll provide the choice of a CSV, JSON and a "Columnar
JSON" format download.

## Screenshots
![](/assets/projects/broom/toolbar.png)
![](/assets/projects/broom/toolbar-granularity.png)
![](/assets/projects/broom/toolbar-error.png)
![](/assets/projects/broom/saving.png)
![](/assets/projects/broom/settings-1.png)

## Technology
- Svelte, Typescript, Tailwind CSS all bundled together with Vite.js

## Neat Details
- Broom has my best library approach to RPC inside of web extensions yet, I'm
  pretty proud of it as it's typesafe, looks like a native promise call and
  supports a variety of uses from fire-and-forget to notify-everything
- Broom uses Svelte integration with Web Components to inject it's UI into a
  webpage in a isolated fashion, a nice upgrade from the iframe setup
  I've used in previous extensions
- Thanks to Chrome's MV3 transition, Broom had a slightly bumpy ride getting
  upgraded to the weird quirks worked out while maintaining compatability with
  Firefox
