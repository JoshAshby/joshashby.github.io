---
title: Welcome to Jekyll!
layout: post
date: '2019-10-07 22:40:57'
tags:
- home
- test

style: |
  body {
    background-color: orange;
  }

  .sidebar-nav, #nav-links {
    background-color: red;
  }

  main {
    background: grey;
  }
---

You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

Jekyll requires blog post files to be named according to the following format:

`YEAR-MONTH-DAY-title.MARKUP`

Where `YEAR` is a four-digit number, `MONTH` and `DAY` are both two-digit numbers, and `MARKUP` is the file extension representing the format used in the file. After that, include the necessary front matter. Take a look at the source for this post to get an idea about how it works.

Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/

<hr />
## Typography
# H1
##  H2
###  H3
####  H4
#####  H5
######  H6

*itallics*

**boooooold**

> someonce said something smart enough for this tag

- one
- two
- three

1. numbers
2. fish
3. red
4. blue

## Images

![](/avatar.jpg)

{% include figure.html src="/avatar.jpg" caption="Brittany" %}

<div class="escape">
  {% include figure.html src="/avatar.jpg" caption="Brittany" %}
</div>

## Code

Fenced

```
testing unhighlighted with a really long line; the quick brown fox jumped over the lazy red cow and ran into chief
```

Fenced with language

```haml
= react_component "open-dialog-button", dialog_id: "bulk-delete"
= react_component "bulk-delete-dialog", id: "bulk-delete"
```

Plain `highlight` tag

{% highlight ruby %}
def test
  do_something()
end
{% endhighlight %}

`highlight` with `linenos`

{% highlight haml linenos %}
%button( data-behavior="open-dialog", data-dialog-id="bulk-delete" )
  Bulk Delete

%dialog#bulk-delete
  %header
    -# Dialog title and a close button could be here
  %section.dialog-main
    -# A table of records or some confirmation message might live here
  %footer
    -# Some actions as buttons or links could be here
{% endhighlight %}

`source` tag with `hl_lines`

{% source ruby hl_lines="1 2 3 4 13 14 15" %}
def self.autorun
  at_exit {
    next if $! and not ($!.kind_of? SystemExit and $!.success?)

    exit_code = nil

    at_exit {
      @@after_run.reverse_each(&:call)
      exit exit_code || false
    }

    exit_code = Minitest.run ARGV
  } unless @@installed_at_exit
  @@installed_at_exit = true
end
{% endsource %}

`source` tag with `location`

{% source haml hl_lines="1 4" location="https://github.com/seattlerb/minitest/blob/1f2b1328f286967926a381d7a34e0eadead0722d/lib/minitest.rb#L52-L66" caption="testing one, two, three" %}
%button( data-behavior="open-dialog", data-dialog-id="bulk-delete" )
  Bulk Delete

%dialog#bulk-delete
  %header
    -# Dialog title and a close button could be here
  %section.dialog-main
    -# A table of records or some confirmation message might live here
  %footer
    -# Some actions as buttons or links could be here
{% endsource %}

## Annotations

{% aside annotations %}
Such as this one!
{% endaside %}

{% aside annotations | red %}
Such as this one!
{% endaside %}

{% aside annotations | orange %}
Such as this one!
{% endaside %}

{% aside annotations | yellow %}
Such as this one!
{% endaside %}

{% aside annotations | blue %}
Such as this one!
{% endaside %}

{% aside annotations | green %}
Such as this one!
{% endaside %}

{% aside annotations | purple %}
Such as this one!
{% endaside %}

## Callouts

{: .callout}
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

{: .callout.red}
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

{: .callout.orange}
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

{: .callout.yellow}
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

{: .callout.blue}
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

{: .callout.purple}
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

{: .callout.green}
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
