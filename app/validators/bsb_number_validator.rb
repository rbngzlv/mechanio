class BsbNumberValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value && !value.to_s.match(regexp)
      record.errors[attribute] << (options[:message] || "is not a valid BSB number")
    end
  end

  def regexp
    /\A\d{6}\z/
  end
end
