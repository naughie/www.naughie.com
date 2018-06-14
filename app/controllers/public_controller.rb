class PublicController < ApplicationController
  before_action :set_source, only: [:update, :destroy]

  def show
    sources = Source.only_public(params[:id])
    not_found(:sources, :show) if sources.blank?
    @source = sources[0]
  end

  def index
    @sources = Source.published.page(params[:page])
  end

  def update
    @source.published!
    reload_page
  end

  def destroy
    @source.unpublished!
    reload_page
  end

  def set_source
    @source = Source.find(params[:id])
  end

  def reload_page
    redirect_to sources_path
  end
end
