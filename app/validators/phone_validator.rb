class PhoneValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value && !value.match(regexp)
      record.errors[attribute] << (options[:message] || "is not a valid phone number")
    end
  end

  def regexp
    /\A04\d{8}\z/
  end
end
