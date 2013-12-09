module AncestryHelper

  def nested_groups(grupos, options = {})
    return '' if grupos.empty?

    collapse_depth = options[:collapse_depth]
    content_tag(:ul) do
      grupos.map do |grupo, sub_grupos|
        content_tag(:li, style: ('display: none' if collapse_depth && grupo.ancestry_depth >= collapse_depth)) do
          nested_title(grupo, options) + nested_groups(sub_grupos, options).html_safe
        end
      end.join.html_safe
    end.html_safe
  end

  def nested_title(grupo, options)
    collapse_depth = options[:collapse_depth]
    content_tag(:span, 'data-region-id' => grupo.id) do
      icon = (collapse_depth && grupo.ancestry_depth >= collapse_depth - 1) ? 'icon-plus-sign' : 'icon-minus-sign'
      content_tag(:i, '', class: icon) + " #{grupo.name} #{grupo.postcode}"
    end
  end

  def regions_tree
    Region.roots.map do |region|
      nested_groups(region.subtree(to_depth: 2).arrange, collapse_depth: 2)
    end.join.html_safe
  end
end
