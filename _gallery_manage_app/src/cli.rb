require "thor"

class Cli < Thor
  check_unknown_options!

  no_commands do
    def exit_on_failure?()= true
  end

  desc :migrate, ""
  option :rollback
  def migrate
    require "sequel/extensions/migration"

    opts = {}
    opts[:relative] = -1 * options.fetch(:rollback, "1").to_i if options.key?(:rollback)

    Sequel::Migrator.run(DB, "migrations/", **opts)
  end

  desc :console, ""
  def console
    require "irb"
    ARGV.clear
    IRB.start
  end

  desc :index, ""
  def index
    RawPhoto.gather
      .each do |raw_photo|
        Models::Photo.new(image: raw_photo.path.open).save
        say_status "done", "Indexed #{raw_photo}"
      end
  end

  desc :phlexify, "Converts html into phlex"
  def phlexify
  end
end
