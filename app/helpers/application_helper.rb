module ApplicationHelper

  def impersonated?
    session[:remember_admin_id]
  end

  def active_li(title, url, current_controllers)
    css = Array(current_controllers).include?(params[:controller]) ? ' active' : ''

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

  def account_status(account, options = {})
    css_class, text = if account.suspended?

      label = if options[:show_suspended_at]
        suspended_date = account.suspended_at.to_s(:date_short)
        "Suspended at #{suspended_date}"
      end

      ['danger', label || 'Suspended']
    else
      ['success', 'Active']
    end
    bootstrap_label(text, css_class)
  end

  def bootstrap_label(text, css_class)
    content_tag :span, text, class: "label label-#{css_class}"
  end

  def suburb_with_postcode(location)
    "#{location.suburb_name}, #{location.postcode}"
  end

  def social_icon(provider)
    icon = provider
    icon = 'google-plus' if provider == 'google_oauth2'
    content_tag :i, '', class: "icon-#{icon}-sign"
  end

  def social_connect_button(provider)
    link_to image_tag("#{provider}-btn.jpg"), user_omniauth_authorize_path(provider), class: "#{provider}-link"
  end

  def twitter_share_link(url, text)
    params = { url: url, text: text }.to_query
    url = "https://twitter.com/intent/tweet?#{params}"
  end

  def twitter_invite_url(invite_url)
    amount = number_to_currency(GIVE_GET_DISCOUNT_AMOUNT, precision: 0)
    text = "Get #{amount} off your next car service or repair. Find, book & have a mechanic come to you @mechanio"
    twitter_share_link(invite_url, text)
  end
end
