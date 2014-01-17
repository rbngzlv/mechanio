class SymptomHierarchy < ActiveRecord::Base
  belongs_to :symptom
  belongs_to :child, class_name: 'Symptom'
  belongs_to :parent, class_name: 'Symptom', foreign_key: :symptom_id
end
