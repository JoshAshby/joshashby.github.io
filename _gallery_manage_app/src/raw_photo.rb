require "mini_exiftool"
require "image_processing/vips"

class RawPhoto
  def self.root()= App.root.join("../_raw_photos/")
  def self.gather()= root.glob("**/*").map { new(_1) }

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def to_s()= path.relative_path_from(self.class.root).to_s
end
