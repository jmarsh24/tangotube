module FullNameable
  extend ActiveSupport::Concern

  included do
    scope :full_name_search, lambda { |query|
                               where("unaccent(name) ILIKE unaccent(:query) OR
                                  unaccent(first_name) ILIKE unaccent(:query) OR
                                  unaccent(last_name) ILIKE unaccent(:query)",
                                     query: "%#{query}%")
                             }
  end

  def full_name
    first_name.present? && last_name.present? ? "#{first_name} #{last_name}" : name
  end

  def abrev_name
    return "" if first_name.blank? || last_name.blank?

    "#{first_name.try(:first).capitalize}. #{last_name.capitalize}"
  end

  def abrev_name_nospace
    abrev_name.try(:delete, " ") if abrev_name.present?
  end
end
