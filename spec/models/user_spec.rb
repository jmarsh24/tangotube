# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  first_name             :string
#  last_name              :string
#  image                  :string
#  uid                    :string
#  provider               :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  role                   :integer
#  supporter              :boolean          default(FALSE)
#

require "rails_helper"

RSpec.describe User do
  fixtures :all

  describe ".sync_with_patreon!" do
    fit "does not update user if they don't have active pledge", :vcr do
      non_supporter = users(:regular)
      User.sync_with_patreon!
      expect(non_supporter.reload.supporter).to eq(false)
    end

    fit "updates user if they have active pledge", :vcr do
      non_supporter = users(:regular)
      User.sync_with_patreon!
      expect(non_supporter.reload.supporter).to eq(true)
    end
  end
end
