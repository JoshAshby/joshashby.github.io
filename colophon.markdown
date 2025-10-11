---
title: Colophon
permalink: "/colophon"
---

### Technologies

- [Jekyll](https://jekyllrb.com/) - a Ruby based static site generator
- A few custom Jekyll plugins
- [TailwindCSS](https://tailwindcss.com/) with the Prose plugin
- Couple lines of hand rolled JS
- Stored on [GitHub](https://github.com/JoshAshby/joshashby.github.io/tree/source)
- Currently built and published via GitHub pages
- [Typst](https://github.com/typst/typst) for the PDF version of my resume

I like the simplicity of Jekyll and appreciate it's Ruby roots. While it's
sometimes a pain in with it's opinions, I haven't found a compelling reason to
leave it and find that I am able to work around issues most of the time. I make
use of categories and data files to power my projects, photography galleries
and blogroll.

I write all my posts in markdown within [(neo)vim](https://neovim.io/), without ceramony. Sometimes
they live as drafts in my [Obsidian](https://obsidian.md/) notes before being copy and pasted into a
file.

I've got a small script that processes images through [imagemagick](https://imagemagick.org/#gsc.tab=0) and dumps them
into an S3 bucket that's configured as a CDN so that larger files are not
included in the GitHub pages release.

### Typography

Previous iterations of this site used system fonts, but I've recently switched
over to using [Scientifica](https://github.com/oppiliappan/scientifica) for page headers and small accents, [Caveat](https://fontsource.org/fonts/caveat)
for more accents, and [IBM Plex](https://www.ibm.com/plex/) for everything else.

### Iconography

Icons around the site come from the [Lucid](https://lucide.dev/) icon project. In the PDF version
of my resume I also use [Feather](https://feathericons.com/) icons, which Lucid is a fork of.

### Components

My {% aside annotations/footnotes %}such as this one{% endaside %} feature is
based on an article I read a _long_ time ago and unfortunately I've lost the
original source. I believe it was a regional radio news station's site, and was
a long form essay on someones life. If you know the source, please email me so
I can give proper attribution here!

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
