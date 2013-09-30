class BootstrapHorizontalTextareaInput < SimpleForm::Inputs::TextInput
  def input
    template.content_tag :div, super, class: 'col-md-6'
  end
end
