class AddUserIdToSources < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :user_id, :integer
    add_index :sources, :user_id
  end
end
