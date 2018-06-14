class ConnectionsController < ApplicationController
  include ConnectionsHelper

  before_action :set_connection, only: [:authorize]
  before_action :set_connection_via_id, only: [:callback]

  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

  def authorize
    redirect_to @conn.redirect_url_for_oauth
  end

  def callback
    flash[:oauth_error] = @conn.fetch_access_token params
    flash[:oauth_success] = 'The access token has been successfully issued.' if flash[:oauth_error].blank?

    redirect_to root_path
  end

  def errors
  end

  private

  def set_connection
    @conn = current_user.connection
  end

  def set_connection_via_id
    @conn = User.find_user_with_state(oauth_params_state).connection
  end

  def oauth_params_state
    params[:state]
  end
end
