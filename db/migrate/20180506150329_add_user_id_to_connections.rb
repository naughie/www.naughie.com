class AddUserIdToConnections < ActiveRecord::Migration[5.1]
  def change
    add_column :connections, :user_id, :integer
    add_index :connections, :user_id
  end
end
