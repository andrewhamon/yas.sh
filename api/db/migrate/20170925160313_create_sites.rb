class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.citext :domain, null: false
      t.references :account, null: false
      t.integer :revision_count, null: false, default: 0
      t.timestamps
    end
    add_index :sites, :domain, unique: true
  end
end
