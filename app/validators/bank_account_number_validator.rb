class BankAccountNumberValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value && !value.to_s.match(regexp)
      record.errors[attribute] << (options[:message] || "is not a valid bank account number")
    end
  end

  def regexp
    /\A\d+\z/
  end
end
