---
title: Modeling Sequenced Keyboard Shortcuts

tags:
- data-structures
- code-adventures
---

{% include annotation-info.html %}

Every couple of projects I run into a situation where I want to have support for sequenced based {% aside keyboard shortcuts. %}
For example, similar to what one finds in Vim, ie: `gg` goes to the top of the file while `g$` goes to the end of the line, and `ciw` deletes the current word under the cursor and drops you into Insert mode.
{% endaside %} But with all of those situations, the desire quickly faded or the project was put aside to chase Yet Another Squirrel and so I never put a lot of thought into the setup of a solution. Over the summer, however, I reached a fairly stable milestone of my RSS reader, [Raton]() and started using it regularly throughout the day. At the time, Raton did not have any keyboard shortcuts at all, so I started small and added support for some basic and chorded shortcuts. Inevitably, that nagging desire of having some fun sequenced keyboard shortcuts resurfaced, and finally having a good playground and use case for them, I was off to the races.

Some what unfortunately, I didn't find a ton resources about how others have solved this problem, so in the spirit of knowledge sharing I figured I'd write down some thoughts and my progression to the solution in Raton as well as do some retro-active dives into other code bases to see how they do it.

## Back to Basics

Before we go too far down the rabbit hole, lets take a look at a very basic approach and build upon it. For this, we'll set the requirement that we don't need {% aside chording support %}

That is, we don't need to track that `ctrl` and `alt` were held for a specific key in the sequence. Check out [Wikipedia](https://en.wikipedia.org/wiki/Chording) to start _another_ rabbit hole, and [Chordie](https://github.com/kbjunky/Chordie) for a real wild time with the dark side.

{% endaside %} for modifier keys, timing requirements around how long a key is held and other odd things, all so that we can store the full sequence as a {% aside string. %}

My general motto for this is to always try to reduce the problem space down to the smallest unit and if you need more, build it up {% aside slowly. %}
But deliberately; Because, you know, incidental complexity and spaghetti code and all that jazz.
{% endaside %}Even if you've got a set of requirements to work within, I've found this really helps for the first iteration because the process can raise questions around assumptions and bring up edge cases.

{% endaside %}

We'll also set an important requirement around the behavior of this system when it comes to partial matches: When a sequence has an exact match, but also is the start of a longer sequence, we'll set a timeout and wait for another key event. If another key event doesn't happen within the window determined by the timeout, we'll accept the current sequence and trigger it's action, otherwise we'll continue on with the sequence matching with the new key event. This'll allow us to handle sets of sequences such as `g`, `gg` and `g$` which all start the same, but perform different actions. Without this requirement, we wouldn't be able to get to `gg` or `g$` because we'd take the action for `g` followed by either `g` (the second one) or `$`.

Because we only need the character of each key in the sequence, as determined by our first requirement, we can store sequences as a string. For storing the complete set of sequences to which actions they map to, we could store our sequences in a look up table. The keys would be our sequences and the action a sequence maps to would be the value. However, our second requirement throws a bit of a wrench into that.

While we could iterate the {% aside look up table's entries %}
Assuming we're in 2021, with a modern language that gives us the ability to iterate a maps keys, values and tuples of entries.

You **are** using a modern language ... aren't you?
{% endaside %}, we'd be better off just storing the sequences in a list, with each entry being a tuple of "sequence, action." This is because we don't gain anything by having a look up table, as we don't need a quick lookup for a single sequence, and we'll have to convert the look up table to a similar list of tuples in order to gather the partial matches anyways so it's worth it to just skip the intermediate and useless look up table.

Now that we've got our data stored, we can start doing things with it. Assuming we've got some event handler hooked up for keyboard key presses: as keys are pressed, our proverbial event handler would append the pressed key's character to a buffer. From there we'd filter down our list of sequences to all the partial matches. If we've only got one partial match, we could check to make sure it's equal and if it is, fire off the action. Otherwise, if multiple matches came back, we'll pick the exact match as our fallback and queue up our timeout.

In {% aside Ruby %}
Yeah, yeah, I know this isn't really ideal code, or even _good_ code, in the ruby world but it's just a demonstration of the concept; Deal with it.
{% endaside %} like syntax for example, this all might look like:

```ruby
sequences = [
  ["g", :doSomethingFun],
  ["gg", :goToTop],
  ["g$", :goToEndOfLine],
]


def event_handler input_buffer
  clear_scheduled_timeouts

  partial_matches = sequences.filter { _1[0].start_with? input_buffer }

  first_match_action = method(partial_matches.first[2])
  return first_match_action.call if partial_matches.length == 1

  schedule_timeout first_match_action
end

event_handler("g")
```

## Vim

To better understand why Vim might have chosen it's method, let's take a look at the environment that it operates in. Vim runs as natively: it's written in C and talks right with the OS.

## Raton


---

As with nearly everything in the land of computers, there are multiple solutions to this problem and each one comes with some trade offs. For Raton I chose what appears to be a slightly less used approach using a form of a tree data structure, while Vim appears to use a {% aside closed addressing hash map. %}A closed addressing hash map is one where collisions are handled by each bucket being a linked list. In Vims case, a collision will place the incoming value as the head of the buckets linked list, and set the buckets previous head as the incoming values "next" link.

You can read the code around this [here for the linked list nodes](https://github.com/vim/vim/blob/9cd063e3195a4c250c8016fa340922ab21fda252/src/structs.h#L1227-L1245) and [here for adding a new entry on collision](https://github.com/vim/vim/blob/4a15504e911bc90a29d862862f0b7a46d8acd12a/src/map.c#L271-L283) and [here for an example of navigating the hash map](https://github.com/vim/vim/blob/4a15504e911bc90a29d862862f0b7a46d8acd12a/src/map.c#L2119-L2185).{% endaside %}
