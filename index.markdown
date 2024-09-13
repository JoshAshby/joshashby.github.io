---
title: Home of Ashby
---

# Hello!

I'm Ashby, a [software dev](https://github.com/JoshAshby) but occasionally I [take photos](/photos/) or worse [write](/posts/).


Looking to get a hold of me?
 - Send me an email at: hello <span class="text-red-900 dark:text-red-500">(at)</span> joshashby <span class="text-red-900 dark:text-red-500">(dot)</span> com
 - Find me on the [libera irc network](https://libera.chat/) as `JoshAshby`
 - Ping me on <a rel="me" href="https://octodon.social/@ashby">Mastodon</a> as `@ashby@octodon.social`

<small>Psst! Did you know that I have an [Atom](/feed.xml) feed of my blog posts available as well‽</small>

<hr />

#### Recent Posts

<div class="flex flex-col space-y-8">
  {% for post in site.posts limit: 5 %}
    {% include post-block.html %}
  {% endfor %}
</div>
