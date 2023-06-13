# frozen_string_literal: true

class FeaturedFilter < Avo::Filters::BooleanFilter
  self.name = "Featured filter"

  def apply(request, query, values)
    return query if values["featured"] && values["unfeatured"]

    if values["featured"]
      query = query.featured
    elsif values["unfeatured"]
      query = query.where(featured: false)
    end

    query
  end

  def options
    {
      featured: "Featured",
      unfeatured: "Unfeatured"
    }
  end

  def default
    {
      featured: false
    }
  end
end
