---
title: Posts by Tag
---

## All Tags

<div class="flex flex-row flex-wrap space-x-1 items-center justify-center flex-grow">
  {% capture tag_names %}
    {% for i in site.tags %}
      {{ i|first }}
    {% endfor %}
  {% endcapture %}

  {% assign tags = tag_names|split: " "|uniq|sort %}

  {% for tag in tags %}
    {% include tag-pill.html tag=tag %}
  {% endfor %}
</div>

## Posts by Tag

{% for i in site.tags %}
  {% assign tag = i | first %}
  {% assign posts = i | last %}

  <a href="#{{ tag | slugify }}" name="{{ tag | slugify }}" class="text-xl">{{ tag }}</a>

  <div class="flex flex-col space-y-8">
    {% for post in posts %}
      {% include post-block.html %}
    {% endfor %}
  </div>

  <hr />
{% endfor %}
