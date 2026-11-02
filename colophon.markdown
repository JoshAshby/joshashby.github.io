---
title: Colophon
permalink: "/colophon"
---

### Technologies

- [Jekyll](https://jekyllrb.com/) - a Ruby based static site generator
    - Plus a few custom Jekyll plugins
- [TailwindCSS](https://tailwindcss.com/) with the Prose plugin
- Couple lines of hand rolled JS managed by an importmap
- All stored on [GitHub](https://github.com/JoshAshby/joshashby.github.io/tree/source)
- Built in GitHub Actions and published via GitHub pages
- And [Typst](https://github.com/typst/typst) powers the PDF version of my resume

I like the simplicity of Jekyll and appreciate it's Ruby roots. While it's
sometimes a pain in with it's opinions, I haven't found a compelling reason to
leave it, and find that I am able to work around issues most of the time. I make
use of categories and data files to power my projects, photography galleries
and blogroll and have a few custom plugins to extend it's markdown parser
(Kramdown) and produce a few custom components.

I write all my posts in markdown, within [(neo)vim](https://neovim.io/), without ceramony. Sometimes
they live as drafts in my [Obsidian](https://obsidian.md/) notes before being copy and pasted into a
file.

I've got a small script that processes images through [imagemagick](https://imagemagick.org/#gsc.tab=0) and dumps them
into an S3 bucket that's configured as a CDN, so that larger files are not
included in the GitHub Pages release.

### Typography

Previous iterations of this site used `system` fonts, but I've recently switched
over to using [Scientifica](https://github.com/oppiliappan/scientifica) for page headers and small accents, [Caveat](https://fontsource.org/fonts/caveat)
for more accents, and [IBM Plex](https://www.ibm.com/plex/) for everything else. I also use IBM Plex in the
PDF version of my resume.

### Iconography

Icons around the site come from the [Lucid](https://lucide.dev/) icon project. In the PDF version
of my resume I also use [Feather](https://feathericons.com/) icons (which Lucid is, incidentally, a fork of).

### Components

#### Footnotes

My ==aside annotations/footnotes[^footnote-demo]== feature is
based on an article I read a _long_ time ago and unfortunately I've lost the
original attribution. I believe it was a regional radio news station's site, and was
a long form essay on someones life. If you know the source, please email me so
I can give proper attribution here!

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
in the way of footnotes and Span IALs and Obsidian and their `==highlighted==`
syntax to munge a "markdown native" version together that uses highlights and
footnotes. I've got two additional Jekyll plugins to support this, one that
adds the highlight syntax to Kramdown and one that converts marked footnotes
into annotations.

These days I can write something like this to get the same output as the
Liquid Tag:

```markdown
==🔴this annotation is red[^demo-1]== and ==i can also pick a custom color[^demo-2]=={:.-orange.squared} via Kramdown span level IALs

[^demo-1]: and functions nicer with having small markdown and pulling the
    injection out into a separate block

[^demo-2]: which are also pretty neat.
```


### Inspirations & Credits

I've drawn a lot of inspiration from around the web for design and content.
While I can't remember every influencial piece, these are the ones that actively
stand out to me.

This colophon is inspired by [Maggie Appleton's](https://maggieappleton.com/colophon), [Gwern's](https://gwern.net/about#colophon) and [Jarema's](https://jarema.me/colophon/), among
others.

My blogroll format, with the site and feed links, and OPML download is my own
recreation of one by [Ed Leeman's](https://edleeman.co.uk/blogroll/).

My LLM/"AI" Policy is inspired by [David Bushell's](https://dbushell.com/ai/) policy, and [Edward Loveall's](https://blog.edwardloveall.com/reject-llms)
article _You Are Allowed To Reject LLMs_.

The "Tags" and "Posts by Tags" feature of my blog archive is directly inspired
by my friend [Robert Carpenter's](https://robacarp.io/tags.html) own tags page.
