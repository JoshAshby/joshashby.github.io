---
title: Project - LimeJuice
permalink: "/projects/limejuice"
---

<div class="not-prose mb-2">
  <div class="relative group">
    <div class="mt-4 flex items-center justify-between text-base font-medium space-x-8">
      <h3>LimeJuice</h3>

      <div class="flex items-center divide-solid divide-x-2 divide-gray-300">
        <a href="https://bones.isin.space/user/JoshAshby/repository/LimeJuice/" class="px-2">
          Code
        </a>
      </div>
    </div>

    <span class="tag">Web Service</span>
  </div>
</div>


**TL;DR** LimeJuice is my own attempt at replicating the great [PocketBase](https://pocketbase.io/)
using Server Side Swift instead of Go, and WASM as the integration language
instead of Javascript.

LimeJuice is still pretty unfinished, and while the "collections" feature
works, most of the interesting WASM integration is still in development.


## Screenshots
{% include figure.html src="/assets/projects/limejuice/viewing-a-collection.png" caption="" %}
{% include figure.html src="/assets/projects/limejuice/editing-a-collection.png" caption="" %}
{% include figure.html src="/assets/projects/limejuice/editing-a-record.png" caption="" %}


## Technology
- SvelteKit (Svelte, Typescript, Skeleton UI/Tailwind CSS)
- Server Side Swift with Vapor 4/Swift 5.9
- JavascriptCore for the JS/WASM engine
- SQLite
- WASM SDK in Zig


## Neat Details
-
