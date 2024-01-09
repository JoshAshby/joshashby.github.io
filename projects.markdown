---
title: Projects
permalink: "/projects/"
---

# Projectfolio

I've got plenty of side projects that range from small experiments, helpful
little tools, to learning aids for new languages or frameworks. Once in a
while they grow into something of their own that I want to share, or at the
least showcase. This list, while certainly not exhaustive, is a small showcase
of those projects that I'm most proud of or get a lot of value out of daily.

{: .callout}
Most of the projects listed here are **not** "finished" and many are in a state
of maintenance or hibernation, but I still found the experience, lessons and
ideas from them fulfilling.

---

<div class="mt-6 grid grid-cols-1 gap-x-8 gap-y-8 sm:grid-cols-2 sm:gap-y-10 lg:grid-cols-3 not-prose">
  {% assign showcased = site.projects|where_exp: 'item', 'item.cover.url' %}
  {% for project in showcased %}
    {% assign latest_log = site.projects|where: "type", "project-log"|where: "project", project.id|sort: date|reverse|first %}

    <div class="group">
      <div class="relative">
        <div class="overflow-hidden bg-gray-100">
          <img src="{{ project.cover.url }}" alt="{{ project.title }}'s cover image" class="object-center object-cover">
        </div>

        <a href="{{ project.url }}">
          <span aria-hidden="true" class="absolute inset-0"></span>
          <span class="sr-only">{{ project.title }}</span>
        </a>
      </div>

      <div class="mt-4 prose prose-sm dark:prose-invert">
        {% for tag in project.tags %}
          <span class="tag">{{ tag }}</span>
        {% endfor %}

        <p class="mt-2">{{ project.cover.description | markdownify | remove: '<p>' | remove: '</p>' }}</p>

        {% if latest_log %}
            <p>Latest log entry: <a href="{{ project.url }}#log">{{ latest_log.date|date_to_string: "ordinal", "US" }}</a></p>
        {% endif %}
      </div>
    </div>
  {% endfor %}
</div>

<div class="mt-6 grid grid-cols-1 gap-x-8 gap-y-8 not-prose w-full">
  {% assign non_showcased = site.projects|where: 'cover.url', nil %}
  {% for project in non_showcased %}
    {% assign latest_log = site.projects|where: "type", "project-log"|where: "project", project.id|sort: date|reverse|first %}

    <div class="group">
      <div class="mt-4 flex items-center justify-between text-base font-medium text-gray-900 space-x-8 relative">
        <h3>
          <a href="{{ project.url }}">
            <span aria-hidden="true" class="absolute inset-0"></span>
            {{ project.title }}
          </a>
        </h3>
      </div>

      <div class="prose prose-sm dark:prose-invert">
        {% for tag in project.tags %}
          <span class="tag">{{ tag }}</span>
        {% endfor %}

        <p class="mt-2">{{ project.cover.description | markdownify | remove: '<p>' | remove: '</p>' }}</p>

        {% if latest_log %}
            <p>Latest log entry: <a href="{{ project.url }}#log">{{ latest_log.date|date_to_string: "ordinal", "US" }}</a></p>
        {% endif %}
      </div>
    </div>
  {% endfor %}
</div>

---

### Project Icon Credits
Because I have no art skills beyond the bug logo.

<ul class="w-full">
  {% for project in site.projects  %}
    {% if project.logo_credit %}
      <li><span class="text-xs font-mono">{{ project.title }}: {{ project.logo_credit | markdownify | remove: '<p>' | remove: '</p>' }}</span></li>
    {% endif %}
  {% endfor %}
</ul>
