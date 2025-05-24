class AddTitleAndContentToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :user, null: false, foreign_key: true
    add_column :posts, :title, :string
    add_column :posts, :status, :integer, default: 0
    add_column :posts, :content, :text
  end
end
