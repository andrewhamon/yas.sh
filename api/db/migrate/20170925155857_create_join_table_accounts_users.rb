class CreateJoinTableAccountsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts_users do |t|
      t.references :account, null: false
      t.references :user, null: false
    end

    add_index :accounts_users, [:account_id, :user_id], unique: true
    add_index :accounts_users, [:user_id, :account_id]
  end
end
