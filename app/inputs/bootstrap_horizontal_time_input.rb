class BootstrapHorizontalTimeInput < SimpleForm::Inputs::DateTimeInput
  def input
    template.content_tag :div, super, :class => "col-md-6"
  end

  def input_type
    'date'
  end
end
