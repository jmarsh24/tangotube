# frozen_string_literal: true

# == Schema Information
#
# Table name: deletion_requests
#
#  id         :bigint           not null, primary key
#  provider   :string
#  uid        :string
#  pid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DeletionRequest < ApplicationRecord
  validates :uid, :provider, :pid, presence: true

  # there can only be one entry with given provider + uid
  validates :uid, uniqueness: {scope: :provider}

  before_validation :set_pid

  def run
    u = User.where(provider:, uid:).first
    if u.present?
      u.destroy!
    end
  end

  def deleted?
    User.where(provider:, uid:).count.zero?
  end

  # ============
  # UTIL
  # ============

  def self.from_signed_fb(req)
    data = DeletionRequest.parse_fb_request(req)
    DeletionRequest.create(provider: "facebook", uid: data["user_id"])
  end

  def self.parse_fb_request(req)
    encoded, payload = req.split(".", 2)
    decoded = Base64.urlsafe_decode64(encoded)
    data = JSON.parse(Base64.urlsafe_decode64(payload))

    # we need to verify the digest is the same
    exp = OpenSSL::HMAC.digest("SHA256", Config.facebook_secret!, payload)

    if decoded != exp
      Rails.logger.debug "FB deletion callback called with weird data"
      return nil
    end

    data
  end

  private

  def set_pid
    if pid.blank?
      self.pid = random_pid
    end
  end

  def random_pid
    SecureRandom.hex(4)
  end
end
