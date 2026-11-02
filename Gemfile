source "https://rubygems.org"

gem "jekyll", "~> 4.2.1"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.16"
  gem "jekyll-sitemap"

  gem "jekyll-archives"

  gem "jekyll-datapage-generator"

  gem "jekyll-admin"
end

install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.1.1", :install_if => Gem.win_platform?

gem "webrick"
gem "debug"

gem "ostruct", "~> 0.6.3"
gem "tsort", "~> 0.2.0"
gem "csv", "~> 3.3"

gem "base64", "~> 0.3.0"

gem "bigdecimal", "~> 4.1"
