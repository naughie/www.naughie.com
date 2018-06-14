class SourcesController < ApplicationController
  include SourcesHelper

  before_action :authenticate_user!
  before_action :set_source, only: [:show, :edit, :update, :destroy]
  before_action :add_editor_buttons_to_gon, only: [:new, :edit]
  before_action :add_button_class_to_gon, only: [:new, :edit]

  def index
    @sources = current_user.sources.page(params[:page])
  end

  def new
    @source = Source.new
  end

  def create
    ext = source_params[:ext]
    ext = ".#{ext}" unless ext.blank? || ext.start_with?('.')
    description = source_params[:description]
    contents = source_params[:contents]
    filename = "#{SecureRandom.hex(20)}#{ext}"

    source = Source.create filename: filename, description: description, user_id: current_user.id
    source.puts contents

    redirect_to action: :index
  end

  def show
  end

  def edit
  end

  def update
    @source.clear_target

    description = source_params[:description]
    contents = source_params[:contents]

    @source.update description: description
    @source.puts contents

    redirect_to action: :index
  end

  def destroy
    @source.destroy
    redirect_to action: :index
  end

  private

  def source_params
    params[:source]
  end

  def set_source
    @source = Source.find(params[:id])
  end

  def add_editor_buttons_to_gon
    gon.editor_buttons = Settings.sources.editor_buttons
  end
end
