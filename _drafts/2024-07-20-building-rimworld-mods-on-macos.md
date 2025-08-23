---
title: Building RimWorld Mods on macOS
date: '2024-07-20'
tags:
- dotnet
- rimworld-mods
---

Recently I've been working on some small personal mods for [Ludeon Studio's RimWorld](https://rimworldgame.com/).

While the modding scene is quite active, most folks appear to be on Windows
machines which makes a lot of the information out there fairly useless or even
outdated for folks such as myself who only have macOS systems to work on. I'm
also fairly naive to the whole dotnet build and setup process so I've had quite
a lot of learning to get to this point, but now I've got a system where I just
type `make` and all of my mods are built, packaged into zip files and installed
into my local RimWorld install's mod directory. I figured that I can compile
some of this information together for others, since it was difficult to figure
out the first time.

<!--more-->

The first thing that you'll need is Dotnet. Older tutorials that I've found all
use Mono but these days dotnet installs just fine on macOS. I personally used
the download straight [from
Microsoft](https://dotnet.microsoft.com/en-us/download), but it looks like
there's a pretty up to date cask for it in Homebrew that should work as well.

After you've got dotnet installed, let's go ahead and make a directory for the
mod to live in:

```shell
mkdir MyAwesomeRimWorldMod
cd MyAwesomeRimWorldMod
```

We'll need a few basic files to get started with, and will end up with this
structure:

```
MyAwesomeRimWorldMod/
├── About
│   └── About.xml
├── Source
│   ├── Properties
│   │   └── AssemblyInfo.cs
│   └──MyAwesomeRimWorldMod.cs
├── MyAwesomeRimWorldMod.csproj
└── makefile
```

You might be able to use the dotnet tooling to initialize a new project, but I
found it easier to just manually do this setup copy-paste process. Personally,
I've taken it a step further and use a small templating tool, akin to pythons
`cookiecutter`, because it's the most comfortable and known to me.

Our `makefile` will orchestrate the whole build, packaging and installation
process. It will:

- Build the C# project if any of the `.cs` files change, placing the .dll into
  the build directory
- Copy assets such as textures, sounds and our XML defs and patches into the
  build directory
- Package the build directory up into a Zip file, to make it easy to send to
  folks or install on other computers
- (Optionally) Install the build directory into the game's mod directory,
  replacing any older version

It'll also have a `setup` target to help fetch any Nuget packages and a `clean`
target to wipe out the build directory.

Some folks use the dotnet build tooling to do the copy & packaging steps, but I
prefer to use `make` here as I understand it better and know how to make it a
bit more resilient.
