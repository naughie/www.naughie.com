module ApplicationHelper
  def link_with_same_text_to jump_to, html_opts = nil
    link_to jump_to, jump_to, html_opts
  end

  def button_class kind
    'btn btn-' +
    case kind
    when :new, :create, :edit, :update, :show_buttons
      'primary'
    when :delete, :clear_button
      'warning'
    when :source_button
      'default'
    when :publish, :unpublish
      'success'
    end
  end

  def dialog kind
    case kind
    when :withdraw
      {
        confirm: 'You are now about to withdraw and all files that you created will be deleted.',
        cancel: 'No!',
        commit: "Yes, I'm sure.",
        title: 'Are you sure to withdraw?',
      }
    end
  end
end
