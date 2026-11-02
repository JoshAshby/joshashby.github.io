---
title: Hello!
---

I'm Ashby, a [software dev](https://github.com/JoshAshby) by day. Occasionally I [write posts](/posts/) and [take photos](/photos/).

Looking to get a hold of me?
 - Send me an email at: hello<span class="text-red-900 dark:text-red-500">[at]</span>joshashby.com
 - Find me on the [libera irc network](https://libera.chat/) as `JoshAshby`
 - Ping me on <a rel="me" href="{{ site.socials.mastodon.url }}">Mastodon</a> as `{{ site.socials.mastodon.handle }}`
 - Ping me on <a rel="me" href="{{ site.socials.atproto.url }}">BlueSky/ATProto</a> as `{{ site.socials.atproto.handle }}`

{: .callout}
Interested in having me on your team? Check out [this page](/resume) for some more background on me, and maybe toss an email my way!

<hr />

#### Recent Posts

<small>Psst! Did you know that I have an [Atom](/feed.xml) feed of my blog posts available as well‽</small>

<div class="flex flex-col gap-y-8">
  {% for post in site.posts limit: 5 %}
    {% include post-block.html %}
  {% endfor %}
</div>
