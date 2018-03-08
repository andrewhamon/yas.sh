class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :tokens do |t|
      t.string :access_token, null: false, index: true, unique: true
      t.references :user, null: false
      t.timestamps
    end
  end
end
