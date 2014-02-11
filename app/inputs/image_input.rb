class ImageInput < SimpleForm::Inputs::FileInput
  def input
    # options and object exists in parent class
    version     = options.delete(:version) || :thumb
    image_url   = object.send("#{attribute_name}_url", version)
    file_name   = object.send("#{attribute_name}").file.filename if object.send("#{attribute_name}?") && options.delete(:show_file_name)
    out = ''
    out += template.image_tag(image_url)
    if file_name
      delete_button = template.content_tag(:span, '×', class: 'btn-change-image btn-delete-image')
      out += template.content_tag(:div, "#{file_name}&nbsp;#{delete_button}".html_safe, class: 'file-input-name', 'data-delete' => "remove_#{attribute_name}")
    end
    out += @builder.file_field(attribute_name, input_html_options)
    template.content_tag :div, out.html_safe, class: input_html_options.delete(:wrap_class)
  end
end
