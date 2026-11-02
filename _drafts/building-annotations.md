---
title: Building Annotations
---





```liquid
{% raw %}
{% aside red this would be the annotations 'title' %}and this would be the text
that expands out when the title is clicked on%{ endaside %}
{% endraw %}
```

Which, as you can imagine, made for a painful authoring experience. These days
I've borrowed a combo of features from [Kramdown](https://kramdown.gettalong.org/) in the way of footnotes and
Span IALs and Obsidian and their `==highlighted==` syntax to munge a "markdown
native" version together that uses highlights and footnotes. I've got two
additional Jekyll plugins to support this, one that adds the highlight syntax
to Kramdown and one that converts marked footnotes into annotations.

These days I can write like this to get the same output in HTML:

```markdown
==🔴this annotation is red[^demo-1]== and ==i can also pick a custom color[^demo-2]=={:.-orange.squared} via Kramdown span level IALs

[^demo-1]: and functions nicer with having small markdown and pulling the
    injection out into a separate block

[^demo-2]: which are also pretty neat.
```

