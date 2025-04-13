module Abilities
  class GuestAbility
    include CanCan::Ability

    # Note: Splitting the abilities into separate classes for better organization
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/split_ability.md
    # using current_ability method in controllers to load the correct ability class
    #   def current_ability
    #     @current_ability ||= GuestAbility.new(current_user)
    #   end
    # using can? method or Post.accessible_by(current_ability, :read) to check permissions
    def initialize(user)
      can :read, Post, public: true # Guests can only read public posts
    end
  end
end
