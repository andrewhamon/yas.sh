class CreateUpstreamFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :upstream_files do |t|
      t.references :account, null: false
      t.citext :md5, null: false
      t.bigint :size, null: false
      t.string :content_type
      t.timestamps
    end
    add_index :upstream_files, [:account_id, :md5], unique: true
  end
end
