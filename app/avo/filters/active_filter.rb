# frozen_string_literal: true

class ActiveFilter < Avo::Filters::BooleanFilter
  self.name = "Active filter"

  def apply(request, query, values)
    return query if values["active"] && values["not_active"]

    if values["active"]
      query = query.active
    elsif values["not_active"]
      query = query.where(active: false)
    end

    query
  end

  def options
    {
      active: "active",
      not_active: "not_active"
    }
  end

  def default
    {
      active: true
    }
  end
end
