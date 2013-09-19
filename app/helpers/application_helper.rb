module ApplicationHelper

  def active_li(title, url, current_controller)
    css = params[:controller] == current_controller ? ' active' : ''

    content_tag :li, class: css do
      link_to title, url
    end
  end

  def active_dropdown(current_controller, &block)
    css = 'dropdown'
    css += ' active' if params[:controller] == current_controller

    content_tag :li, class: css do
      yield
    end
  end
end
