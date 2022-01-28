class ApplicationController < ActionController::Base
  # from devise -make sure that user is signed in before performing any action
  before_action :authenticate_user!

  # from pundit
  # include pundit from everywhere 
  include Pundit

  # Pundit is always called? vid 17:31
  # Pundit: white-list approach, every action will be denied unless explicitly allowed
  # after every action call verify_authorized which calls pundit to see if user is authorized 
  # skip_pundit is a private method of this class
  # every action is similar except for index thats why theres exeption and only exit
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  private

  # skip pundit if user is in a devise_controller / admin / pages
  # update this to skip pundit on specific pages
  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
