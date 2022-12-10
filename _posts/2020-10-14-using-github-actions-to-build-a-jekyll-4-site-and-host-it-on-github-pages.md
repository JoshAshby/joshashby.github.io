---
title: Using Github Actions to build a Jekyll 4 site and host it on Github Pages

tags:
 - github actions
 - jekyll
---

A while back I decided that I was going to move this site from an older [Lektor](https://www.getlektor.com/) setup to [Jekyll](https://jekyllrb.com/) while retaining my Github Pages hosting setup. The reasons behind the move are little more than personal preference, but I had hoped to at least rid myself of Travis CI after being unhappy with Idera's acquisition of it.

I initially planned on taking advantage of the automatic building and hosting of a [Jekyll site on Github Pages](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/setting-up-a-github-pages-site-with-jekyll), however after seeing that I wouldn't be able to have custom build steps such as using PostCSS for a custom theme and being locked into [Jekyll 3](https://pages.github.com/versions/), I had to find my own way for building and deploying the site. Thankfully that's an easy task now as a result of Github Actions which let me both ditch Travis CI and not have to worry about getting another CI runner authorized to push to the repo.

A lot of my setup follows the footsteps of [David Stosik's setup](https://davidstosik.github.io/2020/05/31/static-blog-jekyll-410-github-pages-actions.html), so be sure to give that a read. Additionally, I'm actively modeling my photography page setup after [Brandur's](https://brandur.org/photos) setup and his documentation around how his [site handles them](https://github.com/brandur/sorg/blob/81eb0a6bdfa891156c7124984306488093cdc6f7/docs/photographs.md). I'll have a follow up post on how the photography side of things works once I get it settled.

### Github Actions

If you would like to follow along while reading through my own workflow configuration, you can find it [here](https://github.com/JoshAshby/joshashby.github.io/blob/source/.github/workflows/github-pages.yml).

One of the great things about Github Actions over third-party CI providers is the deep integration with the repository: you can clone, commit and push all out of the box without many issues. This, combined with the reusable and composable actions make it quick and easy to build up powerful workflows.

I should note that these days there are two actions that could be used to simplify some of this:

- [jekyll-action-ts](https://github.com/limjh16/jekyll-action-ts)
- [actions-gh-pages](https://github.com/peaceiris/actions-gh-pages)

These actions were not around when I started this, and I'm choosing not the migrate over because the setup is simple and I don't feel that these actions add any value to my setup.

Before we get too far, a small note of how we'll set things up today: There will be two branches in git, `master` and `source`. The root `/` directory in the `master` branch is where the built Github Pages will be served from, and `source` stores the Jekyll setup. While we could have the pages served from `_site/` in my `source` branch, this means that every build will commit to my working branch, leading to some pains with uncesscessary commits on the working branch.

For some different configuration options, take a look at [these docs](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site).

Thi decision to have two branches means that we'll need to:
- Pull from `source`
- Build Jekyll
-  Commit and Push the built `_site/`directory to `master`

```yaml
on:
  push:
    branches:
      - source
```

The first thing we want to do is to limit the workflow to only run when I push to the `source` branch, so that we don't get our CI into a loop. With Github Actions we do this with the [`on.push.branches`](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#onpushpull_requestbranchestags) setting:

```yaml
jobs:
  github-pages:
    runs-on: ubuntu-latest
```

Next, I personally want to run this on a familiar environment, so we'll use the built in Github Actions `ubuntu` runner, by setting the [`jobs.<job-id>.runs-on`](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on) setting (more info on the available runners [here](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on).

The rest of our work will be in the [`jobs.<job-id>.steps`](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idsteps):

```yaml
    steps:
      - uses: actions/checkout@v2
        with:
				  ref: source
          path: source

      - uses: actions/checkout@v2
        with:
          ref: master
          path: build
```

These two actions are how we'll pull from one branch and push to another, doing two checkouts of the repository at different paths for each branch: The `source` branch that'll we'll use to build the Jekyll site lives at `./source` and the `master` branch at `./build`.

```yaml
      - uses: actions/setup-ruby@v1
        with:
          ruby-version: '2.7'

      - uses: actions/setup-node@v1
        with:
          node-version: '16.4.x'
```

We'll need ruby, and my own setup needs node so lets get those installed.

{% raw %}
```yaml
      - uses: actions/cache@v2
        with:
          path: source/vendor/bundle
          key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile.lock') }}
          restore-keys: |
            ${{ runner.os }}-gems-

      - uses: actions/cache@v2
        with:
          path: source/node_modules
          key: ${{ runner.os }}-npm-${{ hashFiles('**/yarn.lock') }}
          restore-keys: |
            ${{ runner.os }}-npm-

      - name: Bundle install
        working-directory: source
        run: |
          gem install bundler --no-document
          bundle config path vendor/bundle
          bundle install --jobs 4 --retry 3

      - name: Yarn install
        working-directory: source
        run: |
          yarn install
```
{% endraw %}

And now we'll install the dependences in `./source`. We'll use the cache actions to ensure that our dependencies are quick to install leading to faster publishing, and use the hash of the lockfiles to determine which cache to restore.

Now we get to the heart of the workflow, building and publishing the site:

```yaml
      - name: Jekyll Build
        working-directory: source
        env:
          JEKYLL_ENV: production
        run: bundle exec jekyll build -d ../build
```

Instead of building to Jekylls default `_site`, we'll have it build to our checked out `master` branch, at `../build` from inside of `./source`.

And finally we'll publish the site by making a new commit to `master` and push it to the repository with a helpful commit message linking the build back to the `source` commit that triggered it, and set the commiter to show up as your own user on Github:

```yaml
      - name: Commit and push changes to master
        working-directory: build
        run: |
          git config user.name "${GITHUB_ACTOR}"
          git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
          git add .
          git commit -m "Update GitHub pages from Jekyll build for commit ${GITHUB_SHA}"
          git push origin master
```

And that's it! It might look like a lot all spaced out like this, but it's a fairly simple setup that is still powerful and expandable as you add more features to your site such as photograph processing, javascript resource processing or html cleanup in `./build` before publishing.
