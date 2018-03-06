class AddDomainValidationToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :domain_prevalidation_token, :string
    add_column :sites, :domain_prevalidation_content, :string
    add_column :sites, :domain_prevalidated_at, :datetime

    add_index :sites, :domain_prevalidation_token
    add_index :sites, :domain_prevalidated_at
  end
end
