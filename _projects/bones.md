---
showcase: 4
title: Bones
logo_credit: "[Dinosaur Skull by Erik Kuroow from NounProject.com](https://thenounproject.com/icon/dinosaur-skull-347287/)"
cover:
  url: /assets/projects/bones/cover.png
  description: Bones is a small tool for managing remote [Fossil-SCM](https://fossil-scm.org/) repositories, giving an interface to find as well as create new Fossil repositories that can easily be shared and collaborated on remotely.
tags:
  - Web App
links:
  - url: https://bones.isin.space/
    content: Website
  - url: https://bones.isin.space/user/JoshAshby/repository/Bones/
    content: Fossil Repository
---

I've slowly been using Fossil for more of my personal projects. The idea of the
self-contained nature of Fossil as well as the ease to host them remotely
appeals to me a lot, but I wanted a nice interface for creating and navigating to
the various repositories I've got. There's already the great
[Chisel](https://chiselapp.com/) but I enjoy reinventing wheels, and was
looking to build something which I could eventually integrate additional
tooling into, such as a CI/CD pipeline and centralized auth.

## Screenshots
{% include figure.html src="/assets/projects/bones/repos.png" caption="" %}

## Technology
- Ruby, Roda, Sqlite, with some Tailwind CSS bundled together with PostCSS

## Neat Details
- Bones manages Bones' repository.
