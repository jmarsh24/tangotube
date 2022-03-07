class User < ApplicationRecord
  pay_customer
  acts_as_voter

  after_initialize :set_default_role, if: :new_record?
  before_save :tileize_name

  has_many :comments, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [150, nil]
  end

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validate :password_complexity

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :confirmable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :timeoutable,
         :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  enum role: {user: 0, admin: 1}

  def set_default_role
    self.role ||= :user
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password,
    "Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
  end


  def tileize_name
    self.name = name.titleize
    self.first_name = first_name.titleize
    self.last_name = last_name.titleize
  end

  class << self
    def from_omniauth(access_token)
      user = User.where(email: access_token.info.email).first
      user ||= User.create(
          email: access_token.info.email,
          password: Devise.friendly_token[0,20],
          name: access_token.info.name,
          first_name: access_token.info.first_name,
          last_name: access_token.info.last_name,
          image: access_token.info.image,
          uid: access_token.uid,
          provider: access_token.info.provider
        )
      user
    end
  end
end
