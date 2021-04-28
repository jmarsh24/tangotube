class Ahoy::Visit < AhoyRecord
  self.primary_key = 'id'

  has_many :events, class_name: 'Ahoy::Event'
  belongs_to :user, optional: true
end
