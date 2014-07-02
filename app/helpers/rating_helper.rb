module RatingHelper

  def rating_stars(rating = 0)
    html = ''
    (Rating::MAX - rating.to_i).times { html << '<span class="empty-star">&nbsp;</span>'}
    rating.to_i.times { html << '<span class="full-star">&nbsp;</span>'}
    html.html_safe
  end

  def average_rating(rating)
    width = (rating.to_f / Rating::MAX * 100).to_i

    html = ""
    html << "<div class=\"meter\" style=\"width: #{width}%\"></div>"
    Rating::MAX.times { html << '<span class="empty-star">&nbsp;</span>' }
    content_tag :div, html.html_safe, class: 'average-rating'
  end

  def editable_rating(attribute, value)
    html = hidden_field_tag("rating[#{attribute}]", value)
    (1..Rating::MAX).each do |i|
      current = Rating::MAX + 1 - i
      html << content_tag(:span, '&nbsp;'.html_safe, 'data-value' => current, 'class' => ('active' if value == current))
    end
    content_tag :div, html.html_safe, class: 'rating editable'
  end
end
