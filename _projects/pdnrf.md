---
showcase: 5
title: PDNRF
logo_credit: "[Fish by elmars from NounProject.com](https://thenounproject.com/icon/fish-554779/)"
cover:
  url: /assets/projects/pdnrf/cover.png
  description: Please Do **Not** Rob Fish is a small photo organization and hosting site. Born out of the need to use a joke domain `rob.fish`.
tags:
  - Web App
links:
  - url: https://pleasedonot.rob.fish/
    content: Website
  - url: https://bones.isin.space/user/JoshAshby/repository/PleaseDoNotRobFish/
    content: Fossil Repository
---

PDNRF handles optimizing photos, converting videos to gifs (and gifs to videos)
to ease sharing across a variety of mediums and provides some basic tag and
date range searching, along with exposing a description for shared photos. I
tried to design it in a way to help me facilitate sharing screenshots without
needing scp hacks and letting me do so from mobile devices as well.

## Screenshots
{% include figure.html src="/assets/projects/pdnrf/feed.png" caption="" %}
{% include figure.html src="/assets/projects/pdnrf/filters.png" caption="" %}

## Technology
- Ruby, Roda, Sqlite, with some Stimulus.js and Tailwind CSS bundled together with Vite.js
- VIPS and Ffmpeg handle the images and videos/gifs

## Neat Details
- Video transcoding has issues at the moment because PDNRF eats the docker
  containers memory. It's not ideal.
