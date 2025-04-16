class PostPolicy < ApplicationPolicy
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

  def admin_list?
    user.is_a?(Admin)
  end



  private


  # The Scope class is used in conjunction with Pundit policies to determine which records a user is authorized to access
  # based on their role. It defines the rules for filtering records in the database.
  #
  # @param user [User] The user for whom the scope is being defined.
  # @param scope [ActiveRecord::Relation] The initial scope of records to filter.
  #
  # @return [ActiveRecord::Relation] The filtered scope of records that the user is authorized to access.
  # How to use:
  # - In your controller, you can use the policy scope to filter records:
  #  ` - @posts = policy_scope(Post)`
  #    - PublicationPolicy::Scope.new(current_user, Post).resolve
  # - This will return all posts for admins, only the user's posts for regular users, and only published posts for guests.
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.is_a?(Admin)
        scope.all
      elsif user.is_a?(User)
        scope.where(user_id: user.id)
      else
        scope.where(published: true)
      end
    end

    private

    attr_reader :user, :scope
  end
end
