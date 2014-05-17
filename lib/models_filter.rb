class ModelsFilter

  def self.find(model, params)
    year = params.delete(:year)

    params.reject! do |k, v|
      v.blank? || !model.column_names.include?(k.to_s)
    end

    return [] if params.empty? && !year

    relation = model.where(params)

    if year
      relation = relation.joins(:model_variations) unless model.name == 'ModelVariation'
      relation = relation.where('? BETWEEN model_variations.from_year AND model_variations.to_year', year)
    end

    relation.distinct
  end
end
