module RatingHelper

  def rating_stars(rating = 0)
    html = ''
    (Rating::MAX - rating.to_i).times { html << '<span class="empty-star">&nbsp;</span>'}
    rating.to_i.times { html << '<span class="full-star">&nbsp;</span>'}
    html.html_safe
  end

  def editable_rating(field_name)
    html = hidden_field_tag(field_name, '0')
    (1..Rating::MAX).each do |i|
      html << content_tag(:span, '&nbsp;'.html_safe, 'data-value' => Rating::MAX + 1 - i)
    end
    content_tag :div, html.html_safe, class: 'rating editable'
  end
end
