# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    if user.admin?
      can :manage, :all
    else
      can %i(read update), Order, user_id: user.id
      can :create, Order
      can :update, [User, Address], id: user.id
    end
  end
end
