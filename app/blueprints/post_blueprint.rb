class PostBlueprint < Blueprinter::Base
  identifier :id

  field :created_at do |post, _options|
    post.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  field :updated_at do |post, _options|
    post.updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  field :status_text do |post, _options|
    post.status # This returns the string, e.g., "draft", "published", or "archived"
  end

  field :status # Raw status value from database

  fields :title, :content
end
