Sequel.migration do
  up do
    create_table(:photos) do
      primary_key :id

      column :image_data, :json

      text :title, default: "Untitled Photo", null: false
      text :description, default: "", null: false

      column :metadata, :json, default: "[]"
    end
  end

  down do
    drop_table(:photos)
  end
end
