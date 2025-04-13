class CreateManagers < ActiveRecord::Migration[8.0]
  def change
    create_table :managers do |t|
      t.string :name
      t.timestamps
    end
  end
end
