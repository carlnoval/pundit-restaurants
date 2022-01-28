# rails g pundit:policy restaurant
class RestaurantPolicy < ApplicationPolicy
  # this errors out because: https://lewagon-alumni.slack.com/archives/C02E1AF86NQ/p1643033944158700?thread_ts=1642982406.153900&cid=C02E1AF86NQ
  # Yann: `action are only controller methods not policy ones`
  # before_action :creator_or_admin, only: [:update?, :destroy?]

  class Scope < Scope
    # for index methods
    def resolve
      scope.all

      # to only show restaurants created by current user
      # works like Restaurants.where(user: user) but in a more generic way since it can be call from other models
      # scope.where(user: user)
    end
  end

  # method no longer needed
  # reason: `new?` exists in application_policy and calls the `create?` method that lives in this file
  # def new?
  #   true
  # end

  # also called by new? from application_policy
  # this child class has create? so it will use the create? method here
  # if `create?` method does not exist here, flow will look for `create?` in application_policy
  def create?
    true
  end

  def show?
    true
  end

  # same with new? getting rid of this so the flow will look for edit? in application_policy.rb
  # def edit?
  #   # if current_user is owner of restaurant then it should be true else false
  #   # see application policy.rb: user === current_user
  #   # record === @restaurant, argument passed through authorize from res_cont > #set_restaurant method
  #   user == record.user
  # end

  # also called by edit? from application_policy
  # this child class has update? so it will use the update? method here
  def update?
    # if current_user is owner of restaurant then it should be true else false
    # see application policy.rb: user === current_user
    # record === @restaurant, argument passed through authorize from res_cont > #set_restaurant method
    creator_or_admin
  end

  def destroy?
    creator_or_admin
  end

  private

  def creator_or_admin
    user == record.user || user.admin
  end
end
