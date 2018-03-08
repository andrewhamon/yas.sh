class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.references :owner, references: :users, null: false
      t.timestamps
    end
  end
end
