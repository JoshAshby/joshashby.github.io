---
title: I also redid my resume with Typst (and Jekyll)
tags:
- typst
- jekyll
- meta
---

Like [many](https://mattrighetti.com/2023/10/25/i-rewrote-my-cv-in-typst) [folks](https://xeiaso.net/blog/xesite-v4/) [in](https://mattsanetra.uk/blog/bye-latex-hello-typst/) [the](https://tristan.partin.io/blog/2023/08/30/a-love-letter-to-typst/) industry, I too recently rebuilt my resume using [Typst](https://typst.app/) and had a lovely experience doing so.

I'll skip over what [Typst](https://typst.app/) is, since hopefully one of the above folk covers it, but I do want to share how I made my life a little easier by combining Typst and Jekyll.

In addition to a PDF version, I've traditionally kept a version of my resume on this site as a regular webpage, making it easy to point to in a pinch. One of the biggest pains that I've had in the past has been keeping that old Pages based resume and the "resume" page on this website up to date, and more importantly, synced up. It involved a lot of copy-and-paste, formatting (and more reformatting), and was generally just a bummer and a time sink.

Lately, I've been trying to make better use of Jekyll's data files support and thought to myself, "resumes are generally pretty well structured ... gee it'd be nice to put my resume data into a file that Jekyll _AND_ LaTeX can render versions of!"

(Spoilers: Lo and behold, [Xe](https://github.com/Xe/site/blob/e0bc5ecdfafb144a868f0a9aafe33231a1bfd08c/dhall/resume.dhall) already did it!)

The **big** problem with that thought (besides the whole YAML bit) was that I'm not a fan of LaTeX, mostly because I haven't bothered to learn how to use it properly.

That's where the LaTeX ~killer~ alternative and hero of our story, Typst, comes in. I found Typst almost _too_ easy to get started with and pretty quickly had the best-looking version of my resume that I've ever had. However, even though the formatting was a lot easier since markdown and Typst have a lot of overlap, I was still copying content in.

"Let's fix that," I thought.

A cool thing about Typst is that it can [load a variety of data files](https://typst.app/docs/reference/data-loading/), for example YAML:

```typ
let data = yaml("/_data/stuff.yml")
```

That's neat!

Additionally, I can throw that YAML file into my sites `_data/` directory, so that Jekyll will automatically read it into a `site.data.stuff` variable that I can interact with in a template.

From here it was pretty easy to pull out all of the data from my resume into this YAML file, and my Typst code became a series of for loops and templating out data which quickly translated into similar Jekyll Liquid template code.

The end result is three files (plus some supporting font and icon files for the Typst template):

- [`_data/resume.yml`](https://github.com/JoshAshby/joshashby.github.io/blob/bb345c5dea338917c1401437ff1dcfda2c57b655/_data/resume.yml)
- [`resume/_resume2023.typ`](https://github.com/JoshAshby/joshashby.github.io/blob/bb345c5dea338917c1401437ff1dcfda2c57b655/resume/_resume2023.typ)
- [`resume/index.md`](https://github.com/JoshAshby/joshashby.github.io/blob/bb345c5dea338917c1401437ff1dcfda2c57b655/resume/index.md)

Lastly, I wanted the GitHub Actions Workflow [which builds and publishes]({% link _posts/2020-10-14-using-github-actions-to-build-a-jekyll-4-site-and-host-it-on-github-pages.md %}) this site to also keep the Typst generated PDF version up to date. This worked out to be a pretty easy addition, as the command to render the PDF is fairly simple and easily added to the workflow so long as Typst is installed:

```shell
typst compile --root=./ --font-path=assets/fonts/ resume/_resume2023.typ resume.pdf
```

I used the pleasant [typst-community/setup-typst@v3](https://github.com/typst-community/setup-typst) action to get Typst into the environment and then set up the build step to render the PDF version before Jekyll runs:

```yaml
- uses: typst-community/setup-typst@v3
  id: setup-typst
  with:
    typst-version: 'v0.10.0'

- name: Build resume PDF with Typst
  working-directory: source
  run: typst compile --root=./ --font-path=assets/fonts/ resume/_resume2023.typ resume.pdf

- name: Jekyll Build
  working-directory: source
  env:
    JEKYLL_ENV: production
  run: bundle exec jekyll build -d ../build
```

(You can see the full [workflow file here](https://github.com/JoshAshby/joshashby.github.io/blob/694a1d733b90ad0a0648f60338aaaf87f95fff22/.github/workflows/github-pages.yml).)

Now keeping both my site and the nicer PDF version up to date is a breeze, and with the formatting decoupled from the presentation in both versions, it's equally as easy to adjust styling and layout without feeling like I'm starting over with all of the content!

Overall I'd give Typst a 9/10 and would recommend folks check it out if you find yourself writing LaTeX or making documents that render to PDFs often and have the option to look into other tools. It'd be a 10/10 if the error messages were a little better but it's still improving and is already a fantastic tool.
