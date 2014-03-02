module AncestryHelper

  def nested_groups(grupos, options, &block)
    return '' if grupos.empty?

    collapse_depth = options[:collapse_depth]
    content_tag(:ul) do
      grupos.map do |grupo, sub_grupos|
        content_tag(:li) do
          nested_title(grupo, options, &block) + nested_groups(sub_grupos, options, &block).html_safe
        end
      end.join.html_safe
    end.html_safe
  end

  def nested_title(grupo, options, &block)
    content_tag(:span, 'data-region-id' => grupo.id) do
      icon(grupo, options) + block.call(grupo, options[:selected])
    end
  end

  def icon(grupo, options)
    return ''.html_safe if grupo.postcode
    depth = options[:collapse_depth]
    icon_class = (depth && grupo.ancestry_depth >= depth - 1) ? 'icon-plus-sign' : 'icon-minus-sign'
    content_tag(:i, '', class: icon_class)
  end

  def render_tree(root, options, &block)
    group_options = {}
    group_options[:to_depth] = options[:collapse_depth] if options[:collapse_depth]

    subtree = root.descendants(group_options).arrange(order: :name)
    nested_groups(subtree, options, &block).html_safe
  end

  def regions_tree(root, options = {})
    options[:selected] ||= []
    render_tree(root, options) do |grupo, selected|
      check_box_tag('region_id[]', grupo.id, selected.include?(grupo.id)) + " #{grupo.name} #{grupo.postcode}"
    end
  end
end
