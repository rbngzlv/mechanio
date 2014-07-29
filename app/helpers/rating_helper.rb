module RatingHelper

  def rating_stars(rating = 0)
    html = ''
    (Rating::MAX - rating.to_i).times { html << '<span class="empty-star">&nbsp;</span>'}
    rating.to_i.times { html << '<span class="full-star">&nbsp;</span>'}
    html.html_safe
  end

  def average_rating(rating)
    width = rating_to_percent(rating)
    html = ""
    html << "<div class=\"meter\" style=\"width: #{width}%\"></div>"
    Rating::MAX.times { html << '<span class="empty-star">&nbsp;</span>' }
    content_tag :div, html.html_safe, class: 'average-rating'
  end

  def rating_to_percent(rating)
    integer = rating.to_i
    fraction = rating - integer

    width = integer * 100 / Rating::MAX
    width += 10 if fraction.between?(0.01, 0.50)
    width += 20 if fraction.between?(0.51, 0.99)
    width
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
