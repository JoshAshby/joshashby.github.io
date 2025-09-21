require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads")
}

Shrine.plugin :sequel, cache: false
Shrine.plugin :rack_file
Shrine.plugin :derivatives, create_on_promote: true
Shrine.plugin :determine_mime_type, analyzer: :marcel
Shrine.plugin :store_dimensions
