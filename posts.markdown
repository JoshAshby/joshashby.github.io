---
title: Posts
permalink: "/posts/"
---

<!-- Thanks a ton Rob, I owe you 42 bajillion dollars -->
{% capture post_years %}
  {% for post in site.posts %}
  {{ post.date | date: '%Y' }}
  {% endfor %}
{% endcapture %}

{% assign unique_post_years = post_years | split: " " | sort | uniq | reverse %}

<p>
  {% for year in unique_post_years %}
    <a href="/{{year}}">{{year}}</a>
    {% if forloop.last != true %}
    &middot;
    {% endif %}
  {% endfor %}
</p>

[By Tag](/tags)

<small>Psst! Did you know that I have an [Atom](/feed.xml) feed of my blog posts available as well‽</small>

## All Posts

<div class="flex flex-col gap-y-8">
  {% for post in site.posts %}
    {% include post-block.html %}
  {% endfor %}
</div>
