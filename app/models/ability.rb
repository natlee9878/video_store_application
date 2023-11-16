class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.super_user?
      # Super user permissions
      can :manage, :all
    elsif user.admin?
      # Admin permissions
      can :manage, [Video, Actor, User, Stock, Genre, Rental, Notification, RentalsVideo,
                    ActorVideo]
      # Admin can manage users except those with the role 'super_user'
      can :manage, User, role: %w[regular admin]

      # Admin cannot manage users with 'super_user' role
      cannot :manage, User, role: 'super_user'
      #can :read, User, role: 'super_user'
    else
      # Normal user permissions
      can :read, Video
      can :read, Actor
      can :manage, Video, user_id: user.id
      can :manage, Actor, user_id: user.id
    end
  end
end