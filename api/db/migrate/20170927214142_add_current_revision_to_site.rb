class AddCurrentRevisionToSite < ActiveRecord::Migration[5.1]
  def change
    add_reference :sites, :current_revision, references: :revisions
  end
end
