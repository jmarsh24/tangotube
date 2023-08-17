# frozen_string_literal: true

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
#  patreon_id             :string
#
class User < ApplicationRecord
  include Featureable
  include Likeable

  after_initialize :set_default_role, if: :new_record?
  before_save :tileize_name

  has_many :watches, dependent: :destroy
  has_many :watched_videos, through: :watches, source: :video
  has_many :clips, dependent: :nullify
  has_many :recent_searches, dependent: :destroy

  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true
  validates_confirmation_of :password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :confirmable,
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :timeoutable,
    :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  enum role: {user: 0, admin: 1}

  scope :admins, -> { where(role: :admin) }
  scope :non_admins, -> { where(role: :user) }
  scope :search, ->(term) { where("name ILIKE ? OR email ILIKE ?", "%#{term}%", "%#{term}%") }

  class << self
    def from_omniauth(auth)
      user = User.where(email: auth.info.email).first

      if user
        user.update(uid: auth.uid, provider: auth.provider)
      else
        user = User.create(
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          name: auth.info.name,
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          image: auth.info.image,
          uid: auth.uid,
          provider: auth.provider
        )
        user.skip_confirmation!
      end

      user
    end

    def sync_with_patreon!
      api_client = Patreon::API.new(Config.patreon_access_token!)
      campaign_and_patrons = api_client.fetch_campaign_and_patrons
      campaign_and_patrons.data.each do |campaign|
        campaign.pledges.each do |pledge|
          email = pledge.patron.email
          user = User.find_by(email:)
          user.update!(supporter: true) if user.present? && user.supporter == false
        end
      end
    end
  end

  def remember_me
    true
  end

  def set_default_role
    self.role ||= :user
  end

  def tileize_name
    self.first_name = first_name.strip.titleize if name.present?
    self.last_name = last_name.strip.titleize if name.present?
  end

  def watch(video)
    watches.create(video:, watched_at: DateTime.now)
  end
end
