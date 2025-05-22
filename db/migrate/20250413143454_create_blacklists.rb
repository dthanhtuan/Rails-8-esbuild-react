class CreateBlacklists < ActiveRecord::Migration[8.0]
  def change
    create_table :blacklists do |t|
      t.string :token, null: false

      t.timestamps
    end
    add_index :blacklists, :token, unique: true
  end
end
