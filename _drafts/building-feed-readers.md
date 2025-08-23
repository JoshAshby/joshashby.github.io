---
title: Building Feed Readers
description: |
  In response to "The struggles of building a Feed Reader," my own struggles
  and solutions in the space.

date: '2022-06-25'

tags:
- feed readers
- rss
- data pipelines

---

The other day [Jack Evan's "The struggles of building a Feed
Reader"](https://jackevansevo.github.io/posts/struggles-of-building-an-rss-feed-reader/)
pop up in my own feed reader, [Raton](/projects/raton), and I got thinking about
my own struggles and experience in this space. While building Raton I ran into
many of the same problems that Jack covers, but my solutions differ enough that
I figured I'd try and put some words down around them.

<!--I wanted to address some-->
<!--specific points that Jack raises as well as talk more generally about some of-->
<!--the choices and design I made in Raton that has helped me move quickly and-->
<!--support broadly without losing my sanity.-->

For some context: Raton is a feed reader, packaged as a browser extension, that
currently supports RSS 0.9, RSS 1, RSS 2, Atom, and JSON Feed feeds as well as
a number of XML namespace extensions such as Dublin Core, Youtube and iTunes
podcasts. Raton's feed parser architecture allows me to easily and quickly add
new feed formats such as Twitter/Mastodon feeds, XML extensions, and even
custom handling for specific feeds without having to change a ton of code. This
balance of abstraction however came at the price of several refactors and
confronting many of the same problems that caused the struggles Jack brings up.

<!--There's a couple of surface level differences, they used Python and a server-->
<!--side component while Raton is entirely a self-contained browser extension but-->
<!--the difficulties in handling the various feed formats and differences is pretty-->
<!--much universal. Probably because feeds are messy, loose and just like-->
<!--everything else on the internet: don't always follow the standards or best-->
<!--practices.-->

Jack talks about:
- the difference in RSS and Atom
- the lack of specs around feed discovery
- the ambiguity of Atom's entry links
- issues around dates (optional fields, formatting)
- an entry's summary vs description
- more issues around dates (time zones this time)
- putting size constraints in the db
- trying to slugify titles
- relative and absolute links
- cache issues

They're struggles with caching, database constraints and sluggifying titles
are, in my opinion, more self imposed and I'm not sure I necessarily agree
with; I'll touch on those thoughts later, but let's start off with talking
about my favorite subject in readers, formats!

<!--Some of these are architecture issues, some are just the pains of supporting-->
<!--multiple formats and some are the realities of the internet where not everyone-->
<!--will play by the rules (or knows them at all).-->

<!--Struggles around feed formats, their ambiguities and quirks are by far the-->
<!--biggest item for today, but I've included a small addendum at the bottom of-->
<!--the post to directly address a few less feed related items.-->

## RSS RSS RSS ATOM JSON FEED
Jack directly compares the differences between RSS 2 and Atom 1 but there's
3 other formats that a feed reader might want to consider here: RSS 1 (yuck),
RSS 0.9 and JSON Feeds. I have several feeds that are available only as JSON
Feeds and _way too many_ feeds are stuck on RSS 0.9 so supporting these is, in
my opinion, pretty important (even for personal projects).

Naturally different families of formats are going to diverge from each other,
as seen by Atom and RSS 2's differences, but this is true even within the world
of RSS: RSS 1 is _very_ different from 0.9 and 2.

All this is further compounded by the fact that the specs are loose: there are
few required fields, several fields that can mean the same thing to a reader,
and even serialization formats for data like dates is wobbly. And lets not
forget that RSS and Atom both allow XML namespace extensions which exasperates
the issues around duplicate fields!



































## Addendum
I wanted to directly touch on these two items as I think these are pretty quick
to address, fairly isolated from the other issues and not necessarily problems
with just feed readers.

### Caches
Feed readers are lovers of {% aside "Conditional GET" requests. %}Where you
send along a few extra headers like an ETag and Last-Modified and the server
responds with a 304 if you've already seen what it's got laying around{%
endaside %} However, Jack rightfully points out that not every server respects
or uses cache headers then goes on to talk about how this makes it difficult to
lazy parse the feeds to only extract the entries that are new, and considers it
both wasted computation and unwarranted responsibility for having to check for
duplicates yourself.

I posit that the responsibility for checking if you've already seen an entry is
not on the feed but on you, and the "wasted computation" is necessary no matter
what.

You're actually already responsible for duplicate checking because the feed
doesn't know what ETag/Last-Modified you've seen unless you store it and send
it along on every request; ie it is _your_ responsibility to tell the server
what you have and haven't seen. Additionally, the state of your own data is of no
concern to an external system. I shouldn't expect, or ask, a store to know how
much of a product I have at home unless I tell them and even then they
won't necessarily stop showing that product to me just because I did tell
them.

Uniqueness is also a difficult problem in feeds. I'll touch upon it more when
we talk formats but there are feed formats, and just plain-out malformed feeds,
that don't supply unique IDs or links.

Unfortunately, these feeds are not rare, and the existence of them means that
you'll want to have provisions in place to determine if you've seen an entry
already. In my experience, it's far easier to run every entry through this
system than to try and have conditionals in place to catch when it happens.
This comes with an added bonus in that it gives you better control over your
own data consistency and lets you set the rules for what you consider unique.

On the lazy parsing front, that can get pretty gnarly when you start dealing
with different serializations. Additionally, if you're trying to check for
duplicates in the middle of parsing, your going to have a hard time keeping
your parser modular, not tightly coupled to application code and easily
testable.

<!--In my experience, it's far easier to treat the parser as a library and have it-->
<!--take in a url and cache data then spit out a common object which the-->
<!--application code then transforms into database entries. This helps keep a-->
<!--healthy separation of responsibility by letting the application code handle-->
<!--what it cares about, ensuring that it doesn't have any duplicates, and lets the-->
<!--parser just parse. It also makes it easier to test the parser in isolation-->
<!--which makes test scaffolding and case setup much simpler and allows you to more-->
<!--easily rework major parts of the parser without touching a lick of the rest of-->
<!--the application.-->

<!--Those last two points have been vital to Raton's story. The parser is the most-->
<!--well tested part of its code base, and I've done several large rewrites and-->
<!--refactors that haven't needed a single line of code change outside of the-->
<!--parser. I know I can replace the whole parser with a new one without worry.-->

Finally, processing is cheap and computers are _FAST_. All of this
should be happening in a background task already, and taking a few more
milliseconds to check for duplicates should be a non-issue for most projects,
especially personal feed reader tools that aren't serving millions of users.

------

Ultimately, I think cache issues are hit-or-miss and while it is a small amount
of wasted compute when a feed doesn't respect the ETag or Last-Modified
headers, there isn't much you can do and I find any solution just leads to more
difficulty with edge cases abounding.

From my experience, more than half of feed servers don't respect the ETag or
Last-Modfied headers and _always_ return a 200 with the feed contents. You
could do some tricks like hashing the body on your end and not processing it if
you've already seen what the feed just returned to you, but that won't always
work when you get feeds that have some dynamic property that changes per
request because someone didn't implement the spec correctly.

I'll talk more about some architecture decisions I made that simply this
problem for me later, but the best solution I've found for my own sanity as
well as {% aside maintenance %}And avoiding hard to debug issues down the line
when someone complains about a mis-behaving feed not functioning properly ...
{% endaside %} is to just run with it: make sure your processing pipeline is
idempotent to avoid duplicate entries and any feed that doesn't respect cache
headers can get reprocessed even if it ultimately doesn't end up changing the
database.

Taking this approach, while it does push the responsibility of duplicate
tracking down into your code, is actually necessary a lot of the times, if
supporting older formats such as RSS 0.9 which we'll talk about more in a
little bit.

------

**TL;DR**
- Your parser should probably be treated like it's a library
- Avoid coupling your parser to your database or application specific code
- You'll need more control over uniqueness checks as you add support for
  additional formats
- Don't worry and process on. Worst case you waste a second of compute, best
  case you actually find an updated or new entry!

### DB Constraints
This one admittedly had me a little perplexed and reminded me of all the
"Falsehoods programmers believe about XYZ" articles.

> 76. Text will always be sensibly sized
> - Falsehoods programmers believe about the internet

Jack states right out of the gate that neither the RSS nor the Atom specs
define a size limit on various fields, but then goes on to state that they hit
issues when putting size constraints in the DB.

Consider: the internet is not sensible. I've seen feeds that are a sites entire
history from 1998 to today, all in a single response. I've also seen titles so
long they could be their own books and entries that could be longer than The
Wheel of Time series! If there is is a sensible upper end for size then it's on
the limits of tens of megabytes for a title, and hundreds or more for an
entries text content, but for practical purposes it's probably easier to think
and treat of any of the text fields as being unlimited in size.

Now admittedly in the [Lobster discussion
thread](https://lobste.rs/s/u6nrj0/struggles_building_feed_reader#c_sbleh7)
Jack expands on why the limits were put in, saying that they were concerned
about UI's needing to truncate the data. Why not push that limit down the
stack as much as possible?

As [user
`singpolyma`](https://lobste.rs/s/u6nrj0/struggles_building_feed_reader#c_8em3cr)
points out though, that's ultimately a UI decision and not a question of data
modeling, and I agree.

I've found that it's not wise to couple your data model to the UI. Ultimately
the UI is going to need to be very flexible and will be constantly evolving;
It'll need to respond to all different shapes and sizes of screens, it might
have a variety of different presentations of the data and, eventually it'll be
redesigned once or twice.

When any of this happens, you don't want to be changing and refactoring your
whole stack (and possibly hitting some walls where you just _don't have_ the
data because of these limits). Instead, you're much better off if you can just
be adjusting some HTML templates.

**TL;DR**
- Decouple the UI's display of data from the storage and modeling of that data
- Avoid imposing artificial limits on a problem space that allows for a _lot_
  of wiggle room.

Before we dive into the more connected topics, a quick note on slugifying
titles and feed names: ultimately I side-stepped it even more than the
mentioned Feedly et al, and used a UUID for everything. Looking at a feed?
UUID. Looking at a specific entry? UUID. Pretty URLs can have a time and place
but I don't think it's important or worth the trouble for a feed reader where
(at least for me) the point is to abstract away the site into a common
interface. This is obviously subjective so you do you, but I will say that
there are some fine "friendly-url" libraries out there that I'd fallback on if
I wanted to go this route.
