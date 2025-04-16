class Post < ApplicationRecord
  belongs_to :user
  enum :status, { draft: 0, published: 1, archived: 2 }, default: :draft
end
