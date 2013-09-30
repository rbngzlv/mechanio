class BootstrapHorizontalTextInput < SimpleForm::Inputs::Base
  def input
    template.content_tag :div, @builder.text_field(attribute_name, input_html_options), :class => "col-md-6"
  end
end
