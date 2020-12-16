# == Schema Information
#
# Table name: channels
#
#  id         :bigint           not null, primary key
#  title      :string
#  channel_id :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  scanned    :boolean          default(FALSE)
#  last_page  :integer
#

require 'rails_helper'

RSpec.describe Channel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
