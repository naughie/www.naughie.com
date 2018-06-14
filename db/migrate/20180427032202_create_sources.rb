class CreateSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.string :filename
      t.string :description

      t.timestamps
    end
  end
end
