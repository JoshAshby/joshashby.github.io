---
title: Project - PDNRF
permalink: "/projects/pdnrf"
---

<div class="not-prose mb-2">
  <div class="relative group">
    {% include figure.html src="/assets/projects/pdnrf/cover.png" alt="Please do not rob fish cover image" caption='Icon: <a href="https://thenounproject.com/icon/fish-554779/">Fish by elmars from NounProject.com</a>' %}

    <div class="mt-4 flex items-center justify-between text-base font-medium space-x-8">
      <h3>PDNRF</h3>

      <div class="flex items-center divide-solid divide-x-2 divide-gray-300">
        <a href="https://pleasedonot.rob.fish/" class="px-2">
          WWW
        </a>
        <a href="https://bones.isin.space/user/JoshAshby/repository/PleaseDoNotRobFish/" class="px-2">
          Code
        </a>
      </div>
    </div>

    <span class="tag">Web App</span>
  </div>
</div>

**TL;DR** PDNRF, aka Please Do **NOT** Rob Fish, is a small photo sharing and
organizing site for myself; Born out of the need to use the joke domain
`rob.fish` for *anything*.

PDNRF handles optimizing photos, converting videos to gifs (and gifs to videos)
to ease sharing across a variety of mediums and provides some basic tag and
date range searching, along with exposing a description for shared photos. I
tried to design it in a way to help me facilitate sharing screenshots without
needing scp hacks and letting me do so from mobile devices as well.

## Screenshots
![](/assets/projects/pdnrf/feed.png)
![](/assets/projects/pdnrf/filters.png)

## Technology
- Ruby, Roda, Sqlite, with some Stimulus.js and Tailwind CSS bundled together with Vite.js
- VIPS and Ffmpeg handle the images and videos/gifs

## Neat Details
- Video transcoding has issues at the moment because PDNRF eats the docker
  containers memory. It's not ideal.
