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

  def nav_bar_link(title, path, options)
    css = []
    css << options[:li_class].to_s if options[:li_class]
    css << 'active' if current_page?(path) || options[:active]
    content_tag(:li, class: css.join(' ')) do
      i = content_tag(:i, '', class: "glyphicon glyphicon-#{options[:icon]}")
      span = content_tag(:span, i, class: 'img-circle')
      link_to(span + title, path)
    end.html_safe
  end

  def verify_icon(title, icon_type = nil, content = nil)
    content_tag(:i, content, class: "verified-icon #{icon_type}", 'data-original-title' => "#{title}").html_safe
  end
end
