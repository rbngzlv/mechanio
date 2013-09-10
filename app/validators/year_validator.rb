class YearValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    year = value.to_i
    if year < 1960 || year > Date.today.year
      record.errors[attribute] << (options[:message] || "is not a valid year")
    end
  end
end
