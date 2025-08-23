---
title: Forms in SwiftUI for SwiftData & Co
description:

tags:
- swift
- SwiftUI
- SwiftData
---

{% include annotation-info.html %}

I've got two little iOS/macOS apps for myself that I'm currently working on,
and I've had some discovery periods when it comes to forms, so I thought I
might do a small write up on those challenges, and what I've found to work
for me so far and some of the trade offs.

Heads up though, I don't do SwiftUI/iOS work for a living (at least not at the
moment, but I'm happy to give it a try if there's an opportunity!) so there
are probably better ways to do this!

<!--more-->

Here's the scene I found myself in with these two apps: SwiftUI and SwiftData
(one was originally started with CoreData though), and forms. Forms everywhere.

Specifically, these forms needed to create and edit CoreData/SwiftData records,
but I wanted the edits to be in a "draft" state before explicitly saving them
back to the record.

There's a few ways to do this as it turns out. The first approach I started off
using was to open the record in a separate context which had the autosave
feature turned off. This does work, but I found it to be finiky and difficult
to work with in a lot of cases.
