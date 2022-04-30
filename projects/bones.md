---
title: Project - Bones
permalink: "/projects/bones"
---

<div class="not-prose mb-2">
  <div class="relative group">
    {% include figure.html src="/assets/projects/bones/cover.png" alt="Bones cover image" caption='Icon: <a href="https://thenounproject.com/icon/dinosaur-skull-347287/">Dinosaur Skull by Erik Kuroow from NounProject.com</a>' %}

    <div class="mt-4 flex items-center justify-between text-base font-medium space-x-8">
      <h3>Bones</h3>

      <div class="flex items-center divide-solid divide-x-2 divide-gray-300">
        <a href="https://bones.isin.space/" class="px-2">
          WWW
        </a>
        <a href="https://bones.isin.space/user/JoshAshby/repository/Bones/" class="px-2">
          Code
        </a>
      </div>
    </div>

    <span class="tag">Web App</span>
  </div>
</div>

**TL;DR** Bones is a small tool for managing remote [Fossil-SCM](https://fossil-scm.org/)
repositories, giving an interface to find/recall as well as create new
Fossil repositories.

I've slowly been using Fossil for more of my personal projects. The idea of the
self-contained nature of Fossil as well as the ease to host them remotely
appeals to me a lot, but I wanted a nice interface for making and navigating to
the various repositories I've got. There's already the great
[Chisel](https://chiselapp.com/) but I enjoy reinventing wheels, and was
looking to build something which I could eventually integrate additional
tooling into, such as a CI/CD pipeline and centralized auth.

## Screenshots
![](/assets/projects/bones/repos.png)
<!--![](/assets/projects/bones/)-->
<!--![](/assets/projects/bones/)-->

## Technology
- Ruby, Roda, Sqlite, with some Tailwind CSS bundled together with PostCSS

## Neat Details
- Bones manages Bones' repository.
