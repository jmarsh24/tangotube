# frozen_string_literal: true

class HiddenFilter < Avo::Filters::BooleanFilter
  self.name = "Hidden Filter"

  def apply(request, query, values)
    return query if values["hidden"] && values["unhidden"]

    if values["hidden"]
      query = query.hidden
    elsif values["unhidden"]
      query = query.not_hidden
    end

    query
  end

  def options
    {
      hidden: "Hidden",
      unhidden: "Unhidden"
    }
  end

  def default
    {
      hidden: false
    }
  end
end
