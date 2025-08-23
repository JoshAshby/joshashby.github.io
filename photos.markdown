---
title: Photos
permalink: "/photos/"
---

# Shutter Clicks

Some times I take photographs, and in rarer times some of the better ones might end up here. Interested in my [gear?](/photo-gear/)

You can find more of my photos on [my flickr](https://www.flickr.com/photos/joshashby/) {% aside page. %}It's not well maintained by me at the moment, lagging behind by a few years, but it's got a lot of my earlier history.{% endaside %}

I've got one "professional" photo credit to my name so far as the last photo in:

- Redger, Ashlee. “Local Finds: Oso Rojo Hot Sauce Puts Flavor Before Spice” Westworld, 2 Dec. 2022, [https://www.westword.com/restaurants/oso-rojo-hot-sauce-15483836](https://www.westword.com/restaurants/oso-rojo-hot-sauce-15483836)

{: .callout.blue}
Most of these are of a ridiculously cute little dog named Chief. You've been
warned 🙂

<hr/>

{% for photo in site.data.photographs %}
  <figure class="not-prose bg-gray-100 dark:bg-gray-700">
    <img src="{{site.cdn}}/{{photo.slug}}-800.jpg" srcset="{{site.cdn}}/{{photo.slug}}-400.jpg 400w, {{site.cdn}}/{{photo.slug}}-600.jpg 600w, {{site.cdn}}/{{photo.slug}}-800.jpg 800w, {{site.cdn}}/{{photo.slug}}-1000.jpg 1000w" alt="{{photo.title}}"/>

    {% if photo.description != nil and photo.description != '' %}
      <figcaption class="font-mono text-xs text-gray-500 dark:text-gray-200 p-2">{{ photo.description }}</figcaption>
    {% endif %}
  </figure>
{% endfor %}
