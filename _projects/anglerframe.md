---
title: AnglerFrame
cover:
  description: AnglerFrame is a (partial) Swift based port of [Antirez's `kilo` editor](https://github.com/antirez/kilo) and is intended as a learning experiment into VT100 commands as well as more "system" programming using Swift.
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

With AnglerFrame I'm not aiming to make a complete port of `kilo`, at least not
initially, but instead am using it as a sandbox for learning. I don't have a
ton of experience using VT100 commands or making syscalls from Swift, so
having an established and somewhat guided introduction has already been a
wonderful adventure.

## Technology
- Swift 5.9
