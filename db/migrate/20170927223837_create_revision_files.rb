class CreateRevisionFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :revision_files do |t|
      t.references :revision, null: false
      t.references :upstream_file, null: false
      t.string :site_path, null: false

      t.timestamps
    end

    add_index :revision_files, [:revision_id, :site_path], unique: true
  end
end
