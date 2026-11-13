---
title: Custom Footnotes with Jekyll
description: |
  How I extended Jekyll with new markdown syntax and combined it with a custom
  HTML renderer to achieve custom footnote markup in the HTML.
tags: jekyll ruby meta
---

For a while now I've had an "annotation" feature on this site which was
~~inspired by~~ ripped off from the ==🟠web adaptation[^the-designs-of-host]== of [David Foster Wallace's
story "Host" in The Atlantic](https://www.theatlantic.com/magazine/archive/2005/04/host/303812/).

[^the-designs-of-host]: The [original article](https://web.archive.org/web/20160326075128/http://greaterthanorequalto.net/blog/2009/07/david-foster-wallace-different-hosts/) in print is really neat, and it's
    got a fun [evolution of design](https://tumblr.austinkleon.com/post/119707083826) when it was brought online and later modernized!

Historically, it's been powered by a [Jekyll Liquid](https://jekyllrb.com/docs/plugins/tags/) tag that generated the
HTML inline. This works _okay_ but it's a beast to author with, and it never
played well with my RSS feed.

Roughly, to get an annotation such as: ==🔴this would be the annotations 'title'[^demo-annotation]==, you'd write:

[^demo-annotation]: and this would be the text that expands out when the title is clicked on

```liquid
{% raw %}
blah blah blah {% aside red this would be the annotations 'title' %}and this would be the text that expands out when the title is clicked on{% endaside %} blah blah blah blah
{% endraw %}
```

And in RSS land, it spits out something like:

```text
blah blah blah blah Which renders out to: <a href="#annotation-1"
class="annotation-trigger -gray">red this would be the annotations
‘title’</a> <span id="annotation-1" class="annotation"> and this would be the
text that expands out when the title is clicked on </span> blah blah blah blah
```

which ... Isn't ideal on both fronts. Feed readers don't know what to do with
this so it often looks like random gibberish in the middle of paragraphs, and
the authoring experience leaves _a lot_ to be desired.

I've wanted to solve this with something that wasn't to ==🟣tied to
Liquid[^atproto-standard-site]== but I couldn't think of a good syntax. I
wanted to use the footnote syntax `[^1]` to associate the annotations inner
content in a more "out of bands" fashion, which would make authoring and
working with these in a markdown doc easier. The problem is: an annotation
covers multiple words so how do I mark that span?

[^atproto-standard-site]: Preferably something more "markdown native" that is
    easier to type on any keyboard: phone, tablet or laptop. Oh, and because I
    like to create more problems for myself: Also something friendlier to ATProto
    [standard.site](https://standard.site) records, which I'd like to experiement using for new posts.


### The Inspiration

Recently, my [Obsidian](https://obsidian.md/help/syntax#Highlight+colors) updated and the changelog mentioned highlighting via a
`==<stuff>==` like syntax, and I thought: that's pretty neat and sussinct!
Unfortunately it's not a syntax that [Kramdown](https://kramdown.gettalong.org/), the markdown parser that Jekyll
uses out of the box, supports. Big Womp.

It did get me thinking though: what if I combined this syntax with footnotes? I
could then manipulate the generated HTML to rearrange the elements to be like
my original while leaving the markdown untouched so that the RSS feed would get
a much more normal markdown footnote that plays nicer with even the simplest
feed readers.

Long story short: I've extended Kramdown to support the Obsidian style
highlighting syntax, and then layered on a small [Jekyll hook plugin](https://jekyllrb.com/docs/plugins/hooks/)
that rewrites the HTML for footnotes that are wrapped in a `<mark>` tag from
the normal markdown footnotes to my annotation markup.

Now I can write annotations using a much easier syntax and it looks like a
normal markdown footnote in RSS while enhancing on the HTML site:

```markdown
==🔴this annotation is red[^demo-1]== and ==i can also pick a custom color[^demo-2]=={:.-orange.squared} via Kramdown span level IALs

[^demo-1]: and functions nicer with having small markdown and pulling the
    injection out into a separate block

[^demo-2]: which are also pretty neat.
```


### Highlighting with Kramdown

Heads up: The next half of this is a high level look at how to pull this off
but it's lacking in a lot of ancillary details and skips a bunch of code.
I'd recommend checking out the source for these plugins if you're interested:
the [Kramdown extension](https://github.com/JoshAshby/joshashby.github.io/blob/448bbfc3e0871e92c578439b2413ac73642898d4/_plugins/cashby_flavored_markdown.rb) and the [Jekyll hook to rewrite the HTML](https://github.com/JoshAshby/joshashby.github.io/blob/448bbfc3e0871e92c578439b2413ac73642898d4/_plugins/aside.rb)
{:.callout}

The first unlock is getting the Obsidian style highlighting syntax working
within Jekyll. Jekyll uses the [Kramdown](https://kramdown.gettalong.org/)
markdown parser so how can we add in new syntax? It turns out [Bridgetown](https://www.bridgetownrb.com/)
experiemented with this already via [a Monkeypatch of
Kramdowns](https://github.com/bridgetownrb/bridgetown/pull/551) "GitHub Flavored Markdown" processor class that we can leverage most of.

I'd rather deal with inheritance than monkeypatching, however; Is there a
way to avoid this? Turns out there is!

Jekyll lets you set the [processor class](https://jekyllrb.com/docs/configuration/markdown/) it uses via the
`kramdown.input` key in `_config.yml`. With that, we can make our own processor
that inherits from Kramdown and then crib Bridgetown's notes.

If we put this into `_config.yml`:

```yaml
kramdown:
  input: CFM
```

Then we should start with something like the following shoved into a file under
`_plugins/`:

{% source ruby hl_lines="1 5 6" %}
require "kramdown-parser-gfm"

module Kramdown
  module Parser
    class CFM < Kramdown::Parser::GFM
    end
  end
end
{% endsource %}

That's it! Just require the gem and inherit the processor from it into `CFM`.
Now Jekyll will use the `CFM` processor and we can add our custom syntax
parsers there.

Most of what we'll put in this class is copied from Bridgetown but we'll make a
minor set of adjustments to handle the "dot" emoji to set the color.

{% source ruby hl_lines="4 6 7 10 15" %}
def parse_mark
  line_number = @src.current_line_number

  color = emoji_colormap(@src.matched[2])

  start = 2
  start = 3 unless color.nil?

  @src.pos += @src.matched_size
  el = Element.new(:html_element, "mark", { "class" => color }, category: :span, line: line_number)
  @tree.children << el

  preserving_env do
    reset_env(
      src: Kramdown::Utils::StringScanner.new(@src.matched[start..-3], line_number),
      text_type: :text
    )
    parse_spans(el)
  end

  el
end
{% endsource %}

We attempt to match the first character of the contents between the `==` pairs
against a basic map of emoji => color and optionally adjust the starting offset
for the actual text to account for an emoji. The offset is used to let Kramdown
parse the internal content as it normally would. Finally we add a `<mark>`
element to the output where the content will go with a CSS class derived from
the emoji. Kramdown takes care of the rest and handles the nitty gritty around
parsing`==stuff==` into `<mark>stuff</mark>`.

That's it! Now we've got ==highlighting== built into our Jekyll site with a minimal ~90 lines of light Ruby.


### Manipulating HTML

The next part is a bit more tricky. We'll build a `:post_render`
[hook](https://jekyllrb.com/docs/plugins/hooks/) that modifies only the output
HTML that Jekyll will write out, munging footnotes that are wrapped in a
`<mark>` into our annotation markup.

We need to turn:

```html
<mark>I’ve since lost<sup id="fnref:lost-article"><a href="#fn:lost-article" class="footnote" rel="footnote" role="doc-noteref">1</a></sup></mark>

<!-- ... -->

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li id="fn:lost-article">
      <p>If this looks familiar to you and you know the source, please reach out on GitHub or BlueSky! I’d love to give proper attribution for the idea! <a href="#fnref:lost-article" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
  </ol>
</div>
```

into something more like:

```html
<a href="annotation-lost-article" class="annotation-trigger -gray ">I’ve since lost</a>
<span id="annotation-lost-article" class="annotation">If this looks familiar to you and you know the source, please reach out on GitHub or BlueSky! I’d love to give proper attribution for the idea!&nbsp;</span>
```

Because we're in Ruby land, we'll use [Nokogiri](https://nokogiri.org/rdoc/Nokogiri/HTML5/Document.html) to parse and
manipulate the HTML. We can also use some CSS selectors to match elements, for
example, grabbing all of the elements we need to convert: `mark > sup`.

Inside of each `<mark>`, we can grab the anchor's href to get the matching `id`
of the `<li>` that has our footnotes content.

After that, we move some stuff around and delete some old elements, finally
reserializing the document to a string for Jekyll to use.

{% source ruby hl_lines="1 2 3 12 17 23 24 26 27 28 29" %}
doc.css("mark > sup").each do |node|
  reference_id = node.children.attr("href").value.delete_prefix("#")
  reference_content = doc.at_css(".footnotes [id=\"#{reference_id}\"] > p")

  mark = node.parent
  footnote_li = reference_content.parent

  id = reference_id.delete_prefix("fn:")
  classes = node.parent.attr("class") || ""
  color = # ...

  anchor = Nokogiri::XML::Node.new("a", doc) do |node|
    node.children = mark.children
    node["href"] = "annotation-#{id}"
    node["class"] = ["annotation-trigger", color, *classes].join(" ")
  end
  annotation = Nokogiri::XML::Node.new("span", doc) do |node|
    node.children = reference_content.children
    node["id"] = "annotation-#{id}"
    node["class"] = "annotation"
  end

  mark.add_next_sibling(anchor)
  anchor.add_next_sibling(annotation)

  annotation.at_css('a[role="doc-backlink"]').remove
  anchor.at_css('sup').remove
  footnote_li.remove
  mark.remove
end
{% endsource %}

The hooks need to adjust the `#output` attribute of the Jekyll document and
page objects and **not** `#content` so that ==🟡plugins like
`jekyll-feed`[^jekyll-feed-template]== still
get the unchanged markdown footnotes:

```ruby
Jekyll::Hooks.register :documents, :post_render, priority: :high do |doc|
  doc.output = MarkedFootnotesToAnnotations.call(doc.output)
end
```

[^jekyll-feed-template]: `jekyll-feed` uses `post.content` [inside of it's template](https://github.com/jekyll/jekyll-feed/blob/61a0447d10cb263b639c8fd13468676c278f89a6/lib/jekyll-feed/feed.xml#L84), so as long as we don't modify that, we're good.

Finally, we tie it all together with a bit of CSS and JS to make the display
magic, and BOOM! ==🟢Annotations[^boom]==. Now I just need to modernize the
==markup[^invoker-commands]==, ~~expand out the Tailwind `@apply` rules that I
used while hacking this together years ago,~~ and update all my posts and pages
so that I can ditch the Liquid tag! I could also do with adding some nicer
highlight styling CSS to the site. 😅

[^boom]: Scare'd ya, huh?
[^invoker-commands]: Maybe I can leverage the [Invoker Commands API](https://developer.mozilla.org/en-US/docs/Web/API/Invoker_Commands_API) now days?

Lastly, you can find the full implementation hanging around GitHub:
- [Kramdown extension](https://github.com/JoshAshby/joshashby.github.io/blob/448bbfc3e0871e92c578439b2413ac73642898d4/_plugins/cashby_flavored_markdown.rb)
- [Jekyll Hook and Liquid tag](https://github.com/JoshAshby/joshashby.github.io/blob/448bbfc3e0871e92c578439b2413ac73642898d4/_plugins/aside.rb)
- [CSS](https://github.com/JoshAshby/joshashby.github.io/blob/448bbfc3e0871e92c578439b2413ac73642898d4/_frontend/css/annotations.css)
- [JS](https://github.com/JoshAshby/joshashby.github.io/blob/448bbfc3e0871e92c578439b2413ac73642898d4/assets/application.js)

