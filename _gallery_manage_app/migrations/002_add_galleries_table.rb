Sequel.migration do
  up do
    create_table(:galleries) do
      primary_key :id

      text :title, default: "Untitled Gallery", null: false
      text :description, default: "", null: false

      foreign_key :cover_photo_id, :photos
    end
  end

  down do
    drop_table(:galleries)
  end
end
