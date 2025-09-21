---
title: Photos
permalink: "/photos/"
---

# Shutter Clicks

Some times I take photographs, and in rarer times some of the better ones might end up here. Interested in my [gear?](/photo-gear/)

You can find more of my photos on [my flickr](https://www.flickr.com/photos/joshashby/) {% aside page. %}It's not well maintained by me at the moment, lagging behind by a few years, but it has a lot of my earlier history.{% endaside %}

---

## Galleries

{% for gallery in site.data.galleries %}
<div class="flex group py-2 relative min-h-24">
  <div class="mr-4 shrink-0 self-center w-64">
    <img src="{{ site.cdn }}/{{ gallery[1].photographs[0].slug }}-400.jpg"
      alt="Gallery '{{ gallery[1].title }}' cover image"
      class="aspect-auto object-cover group-hover:opacity-75" />
  </div>

  <div class="flex flex-col">
    <h4 class="text-lg font-bold text-gray-900 dark:text-white">
      <a href="/{{ gallery[1].photographs[0].slug | datapage_url: 'photographs' }}">
        <span class="absolute inset-0" aria-hidden="true"></span>
        {{ gallery[1].title }}
      </a>
    </h4>
  
    <p class="mt-1 text-gray-500 dark:text-gray-400">
      {{ gallery[1].description }}
    </p>
  </div>
</div>
{% endfor %}

---

I've got one "professional" photo credit to my name so far as the last photo in:
- Redger, Ashlee. “Local Finds: Oso Rojo Hot Sauce Puts Flavor Before Spice” Westworld, 2 Dec. 2022, [https://www.westword.com/restaurants/oso-rojo-hot-sauce-15483836](https://www.westword.com/restaurants/oso-rojo-hot-sauce-15483836)

