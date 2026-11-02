source "https://rubygems.org"

gem "jekyll", "~> 4"
gem "nokogiri"

group :jekyll_plugins do
  gem "jekyll-feed"
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

