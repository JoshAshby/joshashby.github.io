---
title: SpiderMite-lang
cover:
  description: SpiderMite-lang is a multi-pass programming language implementation that I've been using to explore the ideas of how to implement type-checking and pattern matching.
tags:
  - Programming Language
links:
  - url: https://bones.isin.space/user/JoshAshby/repository/SpiderMite-lang
    content: Fossil Repository
---

I've always been interested in language implementations, and have built a
number of small interpreters of various types and styles, following along with
books such as the fantastic [Robert
Nystrom's](https://journal.stuffwithstuff.com/) _[Crafting
Interpreters](https://craftinginterpreters.com/)_ and [Andrew
Appels's](https://www.cs.princeton.edu/~appel/) _[Modern Compiler
Implementation in ML](https://www.cs.princeton.edu/~appel/modern/ml/)_.

SpiderMite-lang is the next link in this long chain of learning and discovery,
with a focus around more advanced techniques and compiler functionality that
isn't covered well (or at all) in books. It's also one of my first few
"unguided" language implementations, everything has been designed and built
without following along with books or existing tutorials and as such it's
proven quite valuable from the lessons learned as the language has evolved.

The goal with this language is to implement a small ML/Ruby/Swift like language
that has type-checking and pattern matching. Since I want to focus on more
advanced passes within the compiler, the implementation uses a classic but
simple hand written recursive-descent parser and has a basic "reference"
tree-walking interpreter. These choices, while not ground breaking or
interesting, lend themselves to a lot of quick flexibility when it comes to
trying out new ideas around the type system and pattern matching.

Here's a "kitchen sink" example of some SpiderMite code, as it appears in winter of 2023:

```
external def print(_ _: Any) -> Nil
external def toString(_ _: Any) -> String

let b = 1
let c = 41

def matchThings(a: Number) -> String do
    let d = 0

    loop do
        match d with
        | 10 do
            print(10 * 3 + 7)
            break toString(b + c) # "never" type for this branch, `loop` infers to type `String`
        | i do
            print(i)
            d = i + a # value of the match expression isn't captured, it's okay that the branch doesn't align in types with the loop or the other branch
        end
    end
end

print(matchThings(a: 1))
```

## Technology
- Swift 5.9
