class ApplicationController < ActionController::Base
  # before_action :authenticate_user! unless :no_need_to_authenticate_user?
  protect_from_forgery with: :exception
end
