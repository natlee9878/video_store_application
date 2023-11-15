class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.super_user?
      # Super user permissions
      can :manage, :all
    elsif user.admin?
      # Admin permissions
      can :manage, [Video, Actor, User]
      cannot :manage, SuperUser
    else
      # Normal user permissions
      can :read, Video
      can :read, Actor
      can :manage, Video, user_id: user.id
      can :manage, Actor, user_id: user.id
    end
  end
end