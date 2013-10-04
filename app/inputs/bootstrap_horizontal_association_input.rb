class BootstrapHorizontalAssociationInput < SimpleForm::Inputs::CollectionSelectInput
  def input
    wrapper_classes = input_html_options.delete(:wrapper_classes)
    template.content_tag :div, super, class: wrapper_classes
  end
end
