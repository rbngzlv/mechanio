module ApplicationHelper

  def active_li(title, url, current_controller)
    content_tag :li, class: (params[:controller] == current_controller ? 'active' : nil) do
      link_to title, url
    end
  end
end
