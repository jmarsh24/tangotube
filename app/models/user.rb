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
#
class User < ApplicationRecord
  after_initialize :set_default_role, if: :new_record?
  before_save :tileize_name

  has_many :watches, dependent: :destroy
  has_many :watched_videos, through: :watches, source: :video
  has_many :likes, dependent: :destroy
  has_many :liked_videos, through: :likes, source: :likeable, source_type: "Video"

  has_one_attached :avatar

  validates :email, presence: true
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

  def like(video)
    likes.find_or_create_by(likeable: video)
  end

  def unlike(video)
    likes.where(likeable: video).destroy_all
  end

  def watch(video)
    watches.create(video:, watched_at: DateTime.now)
  end

  class << self
    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name   # assuming the user model has a name
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.image = auth.info.image
        user.provider = auth.provider
        user.skip_confirmation!
      end
    end
  end
end
