class PagesController < ApplicationController
  # pundit will not take effect for the specified controller method
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end
end
