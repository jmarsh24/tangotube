# frozen_string_literal: true

class ReviewedFilter < Avo::Filters::BooleanFilter
  self.name = "reviewed Filter"

  def apply(request, query, values)
    return query if values["reviewed"] && values["unreviewed"]

    if values["reviewed"]
      query = query.reviewed
    elsif values["unreviewed"]
      query = query.unreviewed
    end

    query
  end

  def options
    {
      reviewed: "Reviewed",
      unreviewed: "Unreviewed"
    }
  end

  def default
    {
      reviewed: false
    }
  end
end
