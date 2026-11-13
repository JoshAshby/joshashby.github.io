---
permalink: "/colophon"
title: Colophon
description: |
  Inspiration and work that goes into the design and implementation of this site
---

### Technologies

- [Jekyll](https://jekyllrb.com/) - a Ruby based static site generator
    - Plus a few custom Jekyll plugins
- [Typst](https://github.com/typst/typst) powers the PDF version of my resume,
  along with the Open Graph images (via a custom Jekyll plugin)
- [TailwindCSS](https://tailwindcss.com/) with the Prose plugin
- Couple lines of hand rolled JS managed by an importmap (which is also a
  custom Jekyll plugin)
- All stored on [GitHub](https://github.com/JoshAshby/joshashby.github.io/tree/source)
- Built in GitHub Actions and published via GitHub pages

I like the simplicity of Jekyll and appreciate it's Ruby roots. While it's
sometimes a pain with it's opinions, I haven't found a compelling reason to
leave it, and I'm able to work around issues most of the time. I make
use of categories and data files to power my projects, photography galleries
and blogroll and have a few custom plugins to extend it's markdown parser
(Kramdown) and produce a few custom components.

I write all my posts in markdown, within [(neo)vim](https://neovim.io/), without ceramony. Sometimes
they live as drafts in my [Obsidian](https://obsidian.md/) notes before being copy and pasted into a
file.

I've got a small script that processes images through [imagemagick](https://imagemagick.org/) and dumps them
into an S3 bucket that's configured as a CDN, so that larger files are not
included in the GitHub Pages release.


### Inspirations

I've drawn a lot of inspiration from around the web for design and content.
While I can't remember every influencial piece, these are the ones that actively
stand out to me.

My annotations feature is ripped from the web adaptation of [David Foster Wallace's
story "Host" in The Atlantic](https://www.theatlantic.com/magazine/archive/2005/04/host/303812/).

The "Tags" and "Posts by Tags" feature of my blog archive is directly inspired
by my friend [Robert Carpenter's](https://robacarp.io/tags.html) own tags page.

This colophon is inspired by [Maggie Appleton's](https://maggieappleton.com/colophon), [Gwern's](https://gwern.net/about#colophon) and [Jarema's](https://jarema.me/colophon/), among
others.

My blogroll format, with the site and feed links, and OPML download is my own
recreation of one by [Ed Leeman's](https://edleeman.co.uk/blogroll/).

My LLM/"AI" Policy is inspired by [David Bushell's](https://dbushell.com/ai/) policy, and [Edward Loveall's](https://blog.edwardloveall.com/reject-llms)
article "You Are Allowed To Reject LLMs".

My photo workflow is modeled after [Brandur's setup](https://github.com/brandur/sorg/blob/cbd52b385f8962be49ee52e8d15a05efb1c7783a/docs/photographs.md) but with some changes, such as
not being backed by dropbox, and being organized into galleries. The photo
gallery view is inspired by the UI from The Guardian's photo journalism side of
things.

My source highlighting tag is inspired by the code blocks in
[Robert Nystrom's "Crafting Interpreters"](https://craftinginterpreters.com/), with implementation details borrowed
from [shime's Jekyll version](https://shime.sh/til/building-emphasized-code-blocks-in-jekyll).

My Open Graph Images is directly inspired by [Erik André Jakobsen's Astro version](https://eaj.no/posts/open-graph-images-with-typst/).


## Gritty Details

### Typography

Previous iterations of this site used `system` fonts, but I've recently switched
over to using [Scientifica](https://github.com/oppiliappan/scientifica) for page headers and small accents, [Caveat](https://fontsource.org/fonts/caveat)
for more accents, and [IBM Plex Sans](https://www.ibm.com/plex/) for everything else. I also use IBM Plex in the
PDF version of my resume. Scientifica and IBM Plex also make an appearance in
my Open Graph Images.

- <a href="https://github.com/oppiliappan/scientifica" class="font-scientifica">Scientifica</a>
- <a href="https://fontsource.org/fonts/caveat" class="font-caveat">Caveat</a>
- <a href="https://www.ibm.com/plex/" class="font-plex">IBM Plex Sans</a>


### Iconography & Visuals

Icons around the site come from the [Lucid](https://lucide.dev/) icon project. In the PDF version
of my resume I also use [Feather](https://feathericons.com/) icons (which Lucid is, incidentally, a fork of).

My Open Graph Images use a [Hero Patterns](https://heropatterns.com/) pattern, "Topography."

{% include figure.html src="assets/icons/topography.svg" caption="Hero Patterns' 'Topography'" %}


### Components

#### Footnotes

My ==🔵aside annotations/footnotes[^footnote-demo]== feature is based on the web
adaptation of [David Foster Wallace's story "Host" in The Atlantic](https://www.theatlantic.com/magazine/archive/2005/04/host/303812/).

[^footnote-demo]: such as this one

This started life as a basic Liquid tag and was one of my first forays into
Jekyll plugins. Originally you'd define an annotation like so:

```liquid
{% raw %}
{% aside red this would be the annotations 'title' %}and this would be the text
that expands out when the title is clicked on%{ endaside %}
{% endraw %}
```

Which, as you might be able to imagine, made for a painful authoring
experience. These days I've borrowed a combo of features from [Kramdown](https://kramdown.gettalong.org/)
(in the way of footnotes and Span IALs) and Obsidian's `==highlighted==`
syntax to munge a "markdown native" version together. It uses highlights to
mark the span of text that is the "trigger," and footnotes to link to the
annotations contents.

I built two small Jekyll plugins to support this, one that adds the highlight
syntax to Kramdown and one that converts marked footnotes in the HTML into
annotations.

These days I can write something like this to get the same output as the
Liquid Tag:

```markdown
==🔴this annotation is red[^demo-1]== and ==i can also pick a custom color[^demo-2]=={:.-orange.squared} via Kramdown span level IALs

[^demo-1]: and functions nicer with having small markdown and pulling the
    injection out into a separate block

[^demo-2]: which are also pretty neat.
```


#### Source Blocks

When writing technical posts, it can be helpful to include the full block of
code for context, but to only showcase a small section of it. I've got a custom
little Jekyll Liquid tag inspired by the code blocks from
[Robert Nystrom's "Crafting Interpreters"](https://craftinginterpreters.com/), with implementation details from [shime's article](https://shime.sh/til/building-emphasized-code-blocks-in-jekyll):

<div class="default-post">
{% source ruby hl_lines="1 5 6" %}
require "kramdown-parser-gfm"

module Kramdown
  module Parser
    class CFM < Kramdown::Parser::GFM
    end
  end
end
{% endsource %}
</div>


#### Open Graph Images

Every page gets an [Open Graph Image](https://ogp.me/) for fancy unfurls within applications.
This is powered by a small Jekyll plugin that calls out to Typst. This was
inspired by [Erik André Jakobsen's Astro version](https://eaj.no/posts/open-graph-images-with-typst/) and turned out to be really easy to put
together, give that I already have Typst in my build process for my resume's PDF.

{% include figure.html src=page.open_graph_image.url caption="The Open Graph Image for this page, available in the `og:image` meta tag in the document head" %}


#### Importmap

This one isn't a directly visible component, but I've got a Jekyll plugin for
building importmap tag definitions using the same syntax as Rails'. I
originally build this as a Roda plugin for a small CMS manager for this blog.

Behind the scenes I define an importmap in Ruby:

```ruby
pin("application")
```

And then include the tags into the layout with a small Jekyll Liquid tag that
lists the entrypoints to import.

```liquid
{% importmap application %}
```

When rendered, this ends up looking something like:

```html
<script async="" src="https://ga.jspm.io/npm:es-module-shims@2.0.10/dist/es-module-shims.js"></script>

<script type="importmap">
  {
  "imports": {
    "application": "/assets/application.js"
  }
}
</script>

<link rel="modulepreload" href="/assets/application.js">

<script type="module">
   import "application"
</script>
```
