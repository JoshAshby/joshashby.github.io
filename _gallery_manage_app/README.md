# Gallery Manager

An experimental little app to manage the photo galleries on my site.

## Getting Started

Dependencies are managed via [`mise`](https://mise.jdx.dev/) and is set up to
use [`hivemind`](https://github.com/DarthSim/hivemind) to run everything easily:

```shell
mise set MISE_ENV=dev --file mise.local.toml
mise install
mise dev
```

## Styles & JS

The frontend story is intended to be build-less.

JS is managed through
[importmaps](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/script/type/importmap),
[Turbo](https://turbo.hotwired.dev) and [Stimulus
controllers](https://stimulus.hotwired.dev).

Styles are through [Tailwindcss v4](https://tailwindcss.com/docs/installation/play-cdn) via the "Play CDN".

All JS code goes into `/assets/application.js` and similar, the root layout has
a style tag that'll be processed by Tailwind for any custom CSS (but with
limitations).

## Ruby

The entire code-base is setup to auto-reload via [zeitwerk](https://github.com/fxn/zeitwerk). There is a CLI
interface using [Thor](https://www.rubydoc.info/gems/thor/Thor) available too
under `bin/app`.
