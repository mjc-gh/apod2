class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_url
  end
end
