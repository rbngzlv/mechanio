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

  def rating_stars(rating)
    html = ''
    (5-rating).times { html << '<span class="empty-star">&nbsp;</span>'}
    rating.times { html << '<span class="full-star">&nbsp;</span>'}
    html.html_safe
  end
end
