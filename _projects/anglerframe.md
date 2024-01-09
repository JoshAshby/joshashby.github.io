---
title: AnglerFrame
cover:
  description: AnglerFrame is a (partial) Swift based port of [Antirez's `kilo` editor](https://github.com/antirez/kilo)
    and is intended as a learning experiment into VT100 commands as well as more "system"
    programming using Swift.
tags:
- TUI Text Editor
links:
- url: https://bones.isin.space/user/JoshAshby/repository/AnglerFrame
  content: Fossil Repository
---

Like I am with programming languages, I've also always been facinated by TUI
based text editors and when I stumbled across
[`gram`](https://github.com/bingcicle/gram), a Zig port of `kilo` I was hooked
and just knew that one day I'd make my own text editor. When I later found
[this wonderful tutorial](https://viewsourcecode.org/snaptoken/kilo/index.html)
from [Paige](https://viewsourcecode.org/) that breaks down building `kilo` from
the groundup, I just had to get started.

AnglerFrame's top priority is to be a sandbox for learning about topics such as VT100 commands,
raw-mode terminals and TUI implementations and syscalls from Swift. I don't have a ton of experience
with any of these, let alone in Swift, so having an established and somewhat guided
introduction has already been a wonderful adventure.

Notable differences from `kilo`:
- UTF-8 support
- Line numbers
- More Vim-like cursor movement, allowing the cursor to "remember" where it was on longer lines while navigating through a file

### Technology
- Swift 5.9
