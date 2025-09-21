Sequel.migration do
  up do
    create_table(:galleries_photos) do
      foreign_key :gallery_id, :galleries, null: false
      foreign_key :photo_id, :photos, null: false

      primary_key [:gallery_id, :photo_id]
      index [:gallery_id, :photo_id]
    end
  end

  down do
    drop_table(:galleries_photos)
  end
end
