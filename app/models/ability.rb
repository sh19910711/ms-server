class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, App, user_id: user.id
      can :manage, Device, user_id: user.id
      can :create, Deployment
    end
  end
end
