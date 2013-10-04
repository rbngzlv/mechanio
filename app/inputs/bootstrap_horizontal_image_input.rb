class BootstrapHorizontalImageInput < SimpleForm::Inputs::FileInput
  def input
    version = :thumb
    wrapper_classes = input_html_options.delete(:wrapper_classes)
    input_html_options[:class].delete 'form-control'
    out = ''
    if object.send "#{attribute_name}?"
      out << template.image_tag(object.send(attribute_name).tap {|o| break o.send version if version}.send 'url')
    end
    out << @builder.file_field(attribute_name, input_html_options)
    template.content_tag :div, out.html_safe, class: wrapper_classes
  end
end
