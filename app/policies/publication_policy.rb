class PublicationPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post.is_a?(Post) ? post : Post.new
  end

  def update?
    user.is_a?(Admin) || !post.published?
  end

  def edit?
    update?
  end
end
