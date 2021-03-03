# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null
#  visit_id   :bigint
#  user_id    :bigint
#  name       :string
#  properties :jsonb
#  time       :datetime
#
class Ahoy::Event < AhoyRecord
  include Ahoy::QueryMethods

  belongs_to :visit
  belongs_to :user, optional: true
end
