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
      i = content_tag(:i, '', class: "icon-#{options[:icon]}")
      span = content_tag(:span, i, class: 'img-circle')
      link_to(span + title + badge, path)
    end.html_safe
  end

  def verify_icon(title, icon_type = '', is_verified = false, content = nil)
    options = { 'class' => icon_type, 'data-toggle' => 'tooltip' }
    options['data-original-title'] = title if is_verified
    options['class'] << ' disabled' unless is_verified

    content_tag(:i, content, options).html_safe
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

  def job_statuses
    labels = Job::STATUSES.map { |s| I18n.t(s, scope: 'activerecord.attributes.job.status') }
    labels.zip(Job::STATUSES)
  end

  def suburb_with_postcode(location)
    "#{location.suburb}, #{location.postcode}"
  end

  def cost_or_pending(amount)
    amount ? content_tag(:b, number_to_currency(amount)) : 'pending'
  end

  def last_service(car)
    car.last_service_kms ? "#{car.last_service_kms} Km" : car.last_service_date.to_s(:month_year)
  end

  def requested_by(job)
    job.user.full_name + ' on ' + job.created_at.to_s(:date_time_short)
  end

  def allocated_to(job)
    if @job.mechanic && @job.scheduled_at
      @job.mechanic.full_name + ' on ' + job.scheduled_at.to_s(:date_time_short)
    else
      'Unassigned'
    end
  end

  def social_icon(provider)
    icon = provider
    icon = 'google-plus' if provider == 'google_oauth2'
    content_tag :i, '', class: "icon-#{icon}-sign"
  end
end
