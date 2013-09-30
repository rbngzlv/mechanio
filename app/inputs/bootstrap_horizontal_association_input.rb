class BootstrapHorizontalAssociationInput < SimpleForm::Inputs::CollectionSelectInput
  def input
    template.content_tag :div, super, class: 'col-md-6'
  end
end
