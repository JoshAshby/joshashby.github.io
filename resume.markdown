---
title: Resume
permalink: "/resume/"
---

# Joshua Ashby

[Download as a PDF](/resume.pdf)

---

{{ site.data.resume.aboutMe }}

**Primary Technologies:** {{ site.data.resume.primaryTechnologies|join(", ") }}

**Comfortable Tools & Platforms:** {{ site.data.resume.primaryTools|join(", ") }}

## Notable Work

{% for notableItem in site.data.resume.notableWork %}
- {{ notableItem }}
{% endfor %}

## Professional Experience

{% for job in site.data.resume.workExperience %}
<div class="flex content-baseline items-baseline justify-between">
    <h3 class="!p-0 !m-0">
        {{ job.role }}

        {% if job.hats %}
            <small class="!text-xs">{{ job.hats|join("/") }}</small>
        {% endif %}
    </h3>

    {% if job.link %}
        <a href="{{job.link}}">{{ job.company }}</a>
    {% else %}
        {{ job.company }}
    {% endif %}
</div>

<div class="flex align-baseline justify-between">
    {{ job.duration|markdownify }}
    {{ job.location|markdownify }}
</div>

{% for highlight in job.highlights %}
- {{ highlight }}
{% endfor %}
{% endfor %}

---

<small>
    Thanks to <a href="https://feathericons.com/">Feather Icons</a> and <a href="https://www.ibm.com/plex/">IBM Plex Sans</a> which I use in the PDF version of this page.
</small>
