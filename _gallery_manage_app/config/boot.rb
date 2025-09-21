require "bundler/setup"
require "zeitwerk"
require "listen"
require "pathname"

root = Pathname("..").expand_path(__dir__)
root.join("config/initializers").glob("**/*.rb") { load(_1) }

src_loader = Zeitwerk::Loader.new

src_loader.inflector.inflect(
  "html" => "HTML",
)

src_loader.push_dir root.join("src")
src_loader.enable_reloading if ENV["RACK_ENV"] == "development"
src_loader.setup

listener = Listen.to(root) do
  src_loader.reload
end

listener.start
