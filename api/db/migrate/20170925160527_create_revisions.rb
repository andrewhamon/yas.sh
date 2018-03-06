class CreateRevisions < ActiveRecord::Migration[5.1]
  def change
    create_table :revisions do |t|
      t.integer :number, null: false
      t.references :site, null: false
      t.timestamps
    end
    add_index :revisions, [:site_id, :number], unique: true
  end
end
