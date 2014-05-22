module Searchable

  def search(query)
    return where({}) if query.blank?

    conditions = Hash[search_fields.map { |f| [f, query] }]
    fuzzy_search(conditions, false)
  end
end
