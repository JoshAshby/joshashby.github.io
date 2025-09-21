class Models::Gallery < Sequel::Model
  many_to_one :cover_photo, class: Models::Photo
  many_to_many :photos

  # plugin :association_dependencies#, photos: :destroy # destroy photos when gallery is destroyed

  plugin :nested_attributes
  nested_attributes :photos, destroy: true
end
