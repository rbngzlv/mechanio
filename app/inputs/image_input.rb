class ImageInput < SimpleForm::Inputs::FileInput
  def input
    version     = options.delete(:version) || :thumb
    image_url   = object.send("#{attribute_name}_url", version)
    out = ''
    out += template.image_tag(image_url) if image_url
    out += @builder.file_field(attribute_name, input_html_options)
    template.content_tag :div, out.html_safe, class: input_html_options.delete(:wrap_class)
  end
end
