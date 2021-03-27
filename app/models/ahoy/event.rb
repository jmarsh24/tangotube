class Ahoy::Event < AhoyRecord
  include Ahoy::QueryMethods

  belongs_to :visit
  belongs_to :user, optional: true
end
