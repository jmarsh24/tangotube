module Importable
  extend ActiveSupport::Concern
  included do
    scope :imported, -> { where(imported: true) }
    scope :not_imported, -> { where(imported: false) }
  end
end
