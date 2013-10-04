class BootstrapHorizontalTextInput < SimpleForm::Inputs::Base
  def input
    wrapper_classes = input_html_options.delete(:wrapper_classes)
    template.content_tag :div, @builder.text_field(attribute_name, input_html_options), :class => wrapper_classes
  end
end
