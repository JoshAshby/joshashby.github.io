---
title: LimeJuice
cover:
  description: LimeJuice is my own adventure in replicating the great [PocketBase](https://pocketbase.io/) using server side Swift instead of Go, and WASM as the integration language instead of Javascript.
tags:
  - Web Service
links:
  - url: https://bones.isin.space/user/JoshAshby/repository/LimeJuice/
    content: Fossil Repository
---

As of winter of 2023: LimeJuice is still pretty unfinished, and while the
"collections" feature works, most of the interesting WASM integration is still
in development.


## Screenshots
{% include figure.html src="/assets/projects/limejuice/viewing-a-collection.png" caption="" %}
{% include figure.html src="/assets/projects/limejuice/editing-a-collection.png" caption="" %}
{% include figure.html src="/assets/projects/limejuice/editing-a-record.png" caption="" %}


## Technology
- SvelteKit (Svelte, Typescript, Skeleton UI/Tailwind CSS)
- Server side Swift with Vapor 4/Swift 5.9
- JavascriptCore for the JS/WASM engine
- SQLite
- WASM SDK in Zig
