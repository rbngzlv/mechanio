class TaskItem < ActiveRecord::Base

  belongs_to :task
  belongs_to :itemable, polymorphic: true, dependent: :destroy

  accepts_nested_attributes_for :itemable, reject_if: :all_blank

  delegate :cost, :set_cost, to: :itemable, allow_nil: true

  def build_itemable(attrs)
    validate_itemable_type
    self.itemable = itemable_type.constantize.new(attrs)
  end

  def validate_itemable_type
    begin
      assoc = itemable_type.constantize.reflect_on_association(:task_item)
      raise unless assoc.options[:as] == :itemable
    rescue
      raise ActiveRecord::AssociationTypeMismatch, "TaskItem has no association '#{itemable_type}'"
    end
  end
end
