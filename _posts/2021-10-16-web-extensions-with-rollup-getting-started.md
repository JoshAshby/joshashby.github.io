---
title: Browser Extensions with Rollup - Getting Started
layout: post
tags:
- browser-extension
- rollupjs
---

{% include annotation_info.html %}

*Updated 2021-Oct-23 to cleanup some wording and adjust some formatting things*

I've built a number of personal and work related browser extensions over the years and, consequentally, I've tried a number of different patterns for building extensions. For simpler extensions the modern and lightweight [Vanilla JS](http://vanilla-js.com/) can take you pretty far, but sometimes more advanced tooling (or at least more "comfortable" tooling) is either necessary, or at a minimum, desired. For me, it's the latter. I prefer to use [TypeScript](https://www.typescriptlang.org/), [Svelte](https://svelte.dev/) and [Tailwind CSS](https://tailwindcss.com/) as I feel more productive with them and they afford me the developer experience that fits me best at this point in time.

When making the leap from Vanilla JS, one of the first problems that comes up is how to bundle your code which leads to a myriad of choices ranging from older but steady Gulp setups, to stable Webpack all the way to newer and wave making Vite. Often times however, this space lacks attention to brower extension development flows, or presents patterns that are completely incompatable. Historically I've used a Parcel v1 setup, toyed with Webpack and Parcel v2, but over the last two and half years I've been starting new projects, and transitioning old ones, to using [Rollup.js](https://rollupjs.org/) because it provides me with the best over all experience for my needs.

Unfortunately, there wasn't much documentation about getting started with building browser extensions using Rollup.js when I started down this path, and the limited options of plugins and configuration builders that exist often target Chrome/Chromium based browsers only, and have a host of issues with building usable extensions for Firefox. For me, these are deal breakers as I use Firefox as my daily driver browser, and most of my extensions are personal use extensions so I need first class support for Firefox. Consequentally, I've had to forge my own path and figure this out as I go, and I figured I could document some of my learnings, or at least the final process, so today: we'll lay down the ground work and build a basic browser extension using plain old Rollup.js.
## What We'll Build Today
We'll be setting up Rollup.js with some common plugins that will build a basic browser extension; The browser extension will be simple for now, mearly a background page that logs "Hello, World" to the console. We'll also cover how to install your browser extension and test it out in both Firefox and Chrome.

In future posts we'll explore building additional functionality that'll culminate in an extension that: registers a keyword trigger with the browser's URL bar, allows you to configure a set of "aliases" and will redirect you to those aliases when the keyword and alias are typed into the URL bar.

The complete extension will explore background pages, storage in extensions, dedicated pages within the extension for settings, and working with the browsers "web-extension" API. There might be some interludes along the way as well, including: injecting UI into a webpage and showing a popup from the browser action, among others.

{: .callout.info}
**Note** This extension will be built as a "Manifest v2" extension. While this extension should work just fine in Manifest v3 land, due to lack of non-chrome browser support and Googles apparent intent of [ramming through v3](https://www.theregister.com/2021/09/27/google_chrome_manifest_v2_extensions/) to try and styme the danger of ad blockers harming their business, under the guise of "security and performance," {% aside I will not be covering v3 topics at this time and will be focusing on v2 extensions. %}
While I want everyone to go and research the topics to formulate their own opinions, I would recommend a few reading points, including [The Register on the cut to V3](https://www.theregister.com/2021/09/27/google_chrome_manifest_v2_extensions/), and Rich Harris' posts [In defense of the modern web](https://dev.to/richharris/in-defense-of-the-modern-web-2nia) and [Stay Alert](https://dev.to/richharris/stay-alert-d), on my beliefs about why Google may not be the bastion of good for todays Web that they claim to be.
{% endaside %}

## Preparations
After we're done today, our directory should look something like this:

```
.
├── src
│   ├── assets
│   ├── background
│   │   ├── index.html
│   │   └── index.js
│   └── manifest.json
├── package-lock.json
├── package.json
├── rollup.config.js
```

And we'll have a browser extension that loads a basic background page that logs "Hello, World" to the console.

A background page is used in browser extensions to implement long running logic and shared state between tabs, you can read more about them on [MDN here](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Anatomy_of_a_WebExtension#background_scripts). Our extension today won't make heavy use of the background script for now, but we'll expand on uses for it in future posts.

<!-- tree -v --dirsfirst -I 'node_modules' -->

Make a directory where ever best fits for you and cd into it:

```shell
mkdir web-ext && cd web-ext
```

Go ahead and make `src/` and `src/assets/` in this directory too, as they'll come in handy later:

```shell
mkdir -p src/assets/
```

(The `-p` flag will create `src/` if it doesn't exist before creating `src/assets/`)

Then place the following into `package.json` and change the fields as necessary. We'll add to the scripts later on but it's okay to be left empty for now (You can also create this file by running `npm init` and answering the questions).

```json
{
  "name": "web-ext",
  "version": "1.0.0",
  "description": "",
  "scripts": {
  },
  "author": "",
  "license": "ISC"
}
```

## Setup - Rollup
Next lets install Rollup and some common plugins that we'll come in handy down the line:

- `@rollup/plugin-commonjs` Allows us to use CommonJS modules in our builds, especially for non-content scripts which will be bundled as ES modules.
- `@rollup/plugin-node-resolve` Along with the CommonJS plugin, this allows us to import packages installed with NPM.
- `@rollup/plugin-replace` To handle replacing common patterns, words and calls with a predefined format, such as replacing `process.env.NODE_ENV`.
- `rollup-plugin-copy` Will help us copy assets and the manifest file to our build directory.

```shell
npm i rollup @rollup/plugin-commonjs @rollup/plugin-node-resolve @rollup/plugin-replace rollup-plugin-copy --save-dev
```

We'll add more plugins as we go but this'll get us setup and running for now. Next we need to add some basic setup to our `rollup.config.js` to get our background page script `src/background/index.js` compiling. Today we won't do much with the background page script, but I'm using it here to get us up and running and we'll expand on some use of it in future posts.

```javascript
import commonjs from "@rollup/plugin-commonjs"
import replace from "@rollup/plugin-replace"
import resolve from "@rollup/plugin-node-resolve"
import copy from "rollup-plugin-copy"

const production = !process.env.ROLLUP_WATCH
if (production) process.env.NODE_ENV = "production"
const nodeEnv = process.env.NODE_ENV || "development"

export default [
  {
    input: "src/background.js",
    output: {
      sourcemap: !production,
      dir: "dist/background/",
      format: "esm",
    },
    plugins: [
      replace({
        preventAssignment: true,
        values: {
          "process.env.NODE_ENV": JSON.stringify(nodeEnv),
        },
        delimiters: ["", ""],
      }),

      resolve({ browser: true, preferBuiltins: false }),
      commonjs(),

      copy({
        targets: [
          {
            src: `src/manifest.json`,
            dest: "dist/",
          },
          {
            src: "src/background/index.html",
            dest: "dist/background/",
          },
          { src: "src/assets/", dest: "dist/" },
        ],
      }),
    ],
    watch: {
      clearScreen: true,
    },
  },
]
```

(One nice thing about Rollup is that the config file can be normal everyday ES6 syntax which means trailing commas, `import`/`export` statements and destructuring.)

Let's break this down:

```javascript
export default [
  // ...
]
```

In Rollup you can export either a single config object or an array of config objects. We'll jump straight to exporting an array of objects as we'll add another configuration for the pop-up page later which will include the Svelte plugin and have some different needs around what gets copied over.

```javascript
input: "src/background/index.js",
output: {
  sourcemap: !production,
  dir: "dist/background/",
  format: "esm",
},
```

Here we're telling Rollup that we'll package `src/background/index.js` as an ES module (via `format: "esm"`), enabling or disabling sourcemaps according to if this is a production build, and place the output into `dist/background`. Rollup will take care of creating `dist/` and other directories if they doesn't exist which is why we didn't bother with creating it before.

Finally let's take a look at the plugins we'll be using for `src/background/index.js`:

{% source javascript hl_lines="2 4" %}
replace({
  preventAssignment: true,
  values: {
    "process.env.NODE_ENV": JSON.stringify(nodeEnv),
  },
}),
{% endsource %}

As stated above, we'll being using the replace plugin to replace any occurance of `process.env.NODE_ENV` with the value of `NODE_ENV`. This might seem weird to have to do manually if you're coming from Webpack or Parcel, but it's a minimal addition to our config that I don't mind having. We're also telling the plugin that if it detects an assignment to `process.env.NODE_ENV`, it shouldn't replace it with our hard coded string, via the `preventAssignment` option.

{% source javascript hl_lines="2 3 5" %}
resolve({
  browser: true,
  preferBuiltins: false
}),
commonjs(),
{% endsource %}

We need to tell the resolve plugin to act a little differently since we're bundling for a browser, by using any browser configurations found in imported `package.json` and to not try and use Node built ins. We also add support for pulling in CommonJS modules even if we're bundling as an ESM which will greatly increase the number of npm packages we can make use of.

{: .callout}
I've had issues with the node built ins and haven't been able to get polyfills to work or been able to remove the `preferBuiltins` flag. It's only effected a small number of packages, which I've been able to find alternatives for so I just leave this flag in place for now. If anyone has advice on how to get these to play nice together, shoot me a message, I'll give it a go and update this post!

{% source javascript hl_lines="4 8 11" %}
copy({
  targets: [
    {
      src: `src/manifest.json`,
      dest: "dist/",
    },
    {
      src: "src/background/index.html",
      dest: "dist/background/",
    },
    { src: "src/assets/", dest: "dist/" },
  ],
}),
{% endsource %}

And finally we copy over some files. We don't want `dist/` hanging out in our repository so we'll copy it over from `src/`, so that it stays closer to the files it references. Additionally, we'll copy over an HTML file for `src/background/index.js` to live in (more on this in just a second), and finally we'll copy over all assets while we're at it; I throw fonts, SVGs, logos and more into `src/assets/`.

## Setup - Browser Extension
We also need to add `src/background/index.js` and `src/background/index.html`, we'll talk about why we need both in a little bit, they'll look like this:

```javascript
console.log("Hello, World!")
```

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />

    <title>Web Ext</title>

    <script type="module" src="./index.js"></script>
  </head>

  <body></body>
</html>
```

The `type="module"` attribute on the `<script>` tag is the magic to get our ESM bundle to work.

The last part before we can fire up Rollup and give this a go, the magic [`src/manifest.json`](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json) file:

```json
{
  "manifest_version": 2,

  "version": "1.0.0",
  "name": "Web Ext",
  "description": "",

  "background": {
    "page": "background/index.html"
  }
}
```

The `manifest.json` file has to appear at the root of the packaged browser extension and informs the browser about the scripts, permissions, and more that the extension requires. For now, the most important bit is the value of the `background` key. The `background.page` key tells the browser that it doesn't need to create it's own generic HTML page and should instead load our HTML from above which will load our script as an {% aside ES module without issue. %}
If you took a look at the documentation for the `background` key in the manifest, you might be a little confused as to why we're using the `page` option and not the `scripts` option. As it turns out, the browsers don't support loading any ES module via the `scripts` option at the moment, even if they support ESM for web extensions. To get around this issue, we can create our own HTML page which pulls in our code as a module (with that fancy `type="module"` attribute on the `<script />` tag) and then tell the browser to use said page for the extensions background page with the `page` option. This isn't documented on MDN, unfortunately, but there are several other blog posts out there that cover this work around too.
	{% endaside %}

Lets add two scripts to our `package.json` to help us run Rollup in development and production modes a little easier:

{% source json hl_lines="2 3" %}
"scripts": {
  "start:rollup": "rollup -c -w",
  "build:rollup": "rollup -c"
},
{% endsource %}

The `-w` flag tells Rollup to watch the files and rerun the build if anything changes, which comes in handy with developing and iterating.

## But ... Does it Run?
With all that done, let us give this extension a go and make sure things are working:

```shell
npm run start:rollup
```

If everything looks good, you should see something similar to the following:

```
rollup v2.52.7
bundles src/background/index.js → dist/background...
created dist/background in 14ms

[2021-07-04 14:59:16] waiting for changes...
```

And now the moment of truth, does it run? We'll cover both Firefox and Chrome and the process here for loading the development build of the extension won't change as we add more features and functionality.

##### Firefox
In Firefox, type in `about:debugging` into the URL bar and press enter; On the left hand sidebar, select "This Firefox."

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-1.png)

There should be a button labeled "Load Temporary Add-on..." but if it's not visible, you might need to click on the "Temporary Extensions" section to expand it and display the button.

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-2.png)

Click on the button and navigate to your built `dist/` directory and select the `manifest.json` file to load it your extension.

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-3.png)

Next, click on the "Inspect" button on the newly loaded.

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-4.png)

This'll open up a new tab with a developer console and you should see our "Hello, World!" printed out!

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-5.png)
##### Chrome
In Chrome, type in `about:extensions` into the URL bar and press enter. You might need to make sure that that "Developer mode" switch is turned on in order to see the button "Load unpacked"

Click on "Load unpacked" and navigate to your extensions directory and select the `dist/` directory to load your extension.

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/chrome-step-1.png)

Next, click on the "background/index.html" link to open the developer console to the background page's context.

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/chrome-step-2.png)

This'll open a new window with the developer tools for the extensions background page, you might have to navigate to "Console" but you should see out "Hello, World!" printed out just like in Forefox!

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/chrome-step-3.png)

## That's all, folks
Well, for this post at least. Stay tuned for more posts in which we'll continue building off of this foundation and end up with a functional and, potentially, somewhat useful browser extension!
