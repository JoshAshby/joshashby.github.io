require "mini_exiftool"
require "image_processing/vips"

class Uploaders::Photo < Shrine
  THUMBNAILS = {
    huge:   [2000, 2000],
    big:    [1000, 1000],
    large:  [800, 800],
    medium: [600, 600],
    small:  [400, 400],
  }.freeze

  plugin :pretty_location
  plugin :add_metadata

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    THUMBNAILS.transform_values do |(width, height)|
      vips.resize_to_limit!(width, height)
    end
  end

  add_metadata :exif do |io, context|
    MiniExiftool.new(io).to_hash
  end
end
