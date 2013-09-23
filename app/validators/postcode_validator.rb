class PostcodeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value && !value.match(regexp)
      record.errors[attribute] << (options[:message] || "is not a valid postcode")
    end
  end

  def regexp
    /\A(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})\z/
  end
end
