---
title: Home of Ashby
---

# Hello!

I'm Ashby, a [software dev](https://github.com/JoshAshby) but occasionally I [take photos](/photos/) or worse [write](/posts/).

Looking to get a hold of me?
 - Shoot me an email at `me (at) joshashby.com`
 - Find me on the [libera irc network](https://libera.chat/) as `JoshAshby`
 - Ping me on <a rel="me" href="https://octodon.social/@ashby">Mastodon</a> as `@ashby@octodon.social`

<hr />

#### Recent Posts

<div class="flex flex-col space-y-8">
  {% for post in site.posts limit: 5 %}
    {% include post_block.html %}
  {% endfor %}
</div>
