class Ability
  include CanCan::Ability

  # Define abilities for the passed in user here. For example:
  #
  #   user ||= User.new # guest user (not logged in)
  #   if user.admin?
  #     can :manage, :all
  #   else
  #     can :read, :all
  #   end
  #
  # The first argument to `can` is the action you are giving the user
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on.
  # If you pass :all it will apply to every resource. Otherwise pass a Ruby
  # class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the
  # objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

  # NOTE: By default, CanCanCan assumes no permissions: no one can do any action on any object.
  def initialize(user)
    if user.is_a?(Admin)
      can :manage, :all # Admins can manage everything
    elsif user.is_a?(Manager)
      can :approve, Project # Custom action for Managers to approve projects
      can :manage, Project, manager_id: user.id # Managers can manage their own projects
      can :read, Project # Managers can read all projects
    elsif user.is_a?(User)

      can :read, Post, public: true # Users can read public posts
      can :read, Post, user_id: user.id # Users can read their own posts
    else
      can :read, Post, public: true # Guests can only read public posts
    end
  end
end
