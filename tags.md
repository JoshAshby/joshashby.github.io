---
title: Posts by Tag
---

### Posts by Tag

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
