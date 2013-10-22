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

  def count_for_badge(collection)
    (count = collection.count) > 0 ? count : nil
  end

  def nav_bar_link(title, path, options)
    css = []
    css << options[:li_class].to_s if options[:li_class]
    css << 'active' if current_page?(path) || options[:active]
    badge = options[:badge] ? content_tag(:span, options[:badge], class: 'badge badge-important') : nil
    content_tag(:li, class: css.join(' ')) do
      i = content_tag(:i, '', class: "glyphicon glyphicon-#{options[:icon]}")
      span = content_tag(:span, i, class: 'img-circle')
      link_to(span + title + badge, path)
    end.html_safe
  end

  def verify_icon(title, icon_type = nil, is_verified = nil, content = nil)
    content_tag(:i, content, class: "verified-icon #{icon_type} #{is_verified ? nil : 'disabled'}", 'data-original-title' => "#{title}", 'data-toggle' => 'tooltip').html_safe
  end

  def job_status(status)
    css = case status
      when 'pending'    then 'warning'
      when 'estimated'  then 'info'
      when 'assigned'   then 'primary'
      when 'completed'  then 'success'
      when 'cancelled'  then 'default'
    end

    content_tag :span, status.humanize, class: "label label-#{css}"
  end
end
