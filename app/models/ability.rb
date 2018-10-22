class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :real
        can :manage, :all
    else
        can :create, :user
    end
  end
end
