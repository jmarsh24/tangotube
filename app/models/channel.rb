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

class Channel < ApplicationRecord
end
