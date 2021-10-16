source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> 4.2.1"

gem "webrick"
# gem "ffi", "~> 1.15.3"

# Required for now to get the line highlighting in the source_block
# plugin
gem "rouge", github: "rouge-ruby/rouge"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
# gem "minima", "~> 2.5"
# gem "moving"

# If you have any plugins, put them here!
group :jekyll_plugins do
  # If you want to use GitHub Pages, remove the "gem "jekyll"" above and
  # uncomment the line below. To upgrade, run `bundle update github-pages`.
  # gem "github-pages"

  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"

  gem "jekyll-archives"

  gem "jekyll-admin"

  gem "jekyll-vite"
  # gem "jekyll-postcss"
  # gem "jekyll-purgecss"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?
