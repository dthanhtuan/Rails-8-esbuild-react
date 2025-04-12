class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.belongs_to :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
