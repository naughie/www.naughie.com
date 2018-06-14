class AddStatusToSources < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :status, :boolean, default: false
    add_index :sources, :status
  end
end
