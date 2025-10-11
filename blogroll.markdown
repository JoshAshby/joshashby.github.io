---
title: "Blogroll"
permalink: "/blogroll"
---

Sites and blogs that I follow, or recommend.

<small>You can also download this list as an [OPML](/blogroll.opml) to import into your feed reader!</small>

<ul class="w-full list-none [padding-inline-start:0]">
{% for blog in site.data.blogroll.blogs %}
<li class="flex flex-row justify-between">
  <a href="{{ blog.url }}" class="underline">{{ blog.title }}</a>

  {% if blog.feed_url %}
  <a href="{{ blog.feed_url }}" class="underline">Feed</a>
  {% endif %}
</li>
{% endfor %}
</ul>
