class RemoveRefreshTokenFromConnection < ActiveRecord::Migration[5.1]
  def change
    remove_column :connections, :refresh_token, :string
  end
end
