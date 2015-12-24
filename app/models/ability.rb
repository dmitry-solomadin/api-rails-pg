class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :read, :all
    elsif user.admin?
      can :manage, :all
    else
      can :create, :all
      can [:update, :destroy], :all, :author_id => user.id
    end
  end
end
