require "sequel"

DB = Sequel.sqlite "gallery.db"

Sequel::Model.db = DB

Sequel::Model.plugin :nested_attributes
Sequel::Model.plugin :association_dependencies
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :forme

Sequel.extension :fiber_concurrency
Sequel.extension :sqlite_json_ops
