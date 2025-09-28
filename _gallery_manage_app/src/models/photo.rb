class Models::Photo < Sequel::Model
  include Uploaders::Photo::Attachment(:image)

  many_to_many :gallerys

  plugin :serialization, :json, :metadata
end
