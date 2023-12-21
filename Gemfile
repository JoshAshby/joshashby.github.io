source "https://rubygems.org"

gem "jekyll", "~> 4.2.1"

group :jekyll_plugins do
  gem "jekyll-vite"

  gem "jekyll-feed", "~> 0.16"
  gem "jekyll-sitemap"
  gem "jekyll-seo-tag"

  gem "jekyll-archives"

  gem "jekyll-admin"
end

install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

gem "webrick"
