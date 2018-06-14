module SourcesHelper
  include ApplicationHelper

  def button_size
    'col-xs-3 col-lg-1 col-md-2 col-sm-2'
  end

  def add_button_class_to_gon
    gon.button_class = "#{button_class(:source_button)} #{button_size}"
  end
end
