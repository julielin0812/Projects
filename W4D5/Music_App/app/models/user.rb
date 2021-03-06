class User < ApplicationRecord
  validates :email, :password_digest, :session_token, presence: true
  validates :password, length: { minimum 6, allow_nil: true }

  after_initialize :ensure_session_token

# Remember that in the User model, you'll want to use an after_initialize callback to set the session_token before validation if it's not present.
# Write a User::find_by_credentials(email, password) method.
  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email: email)
    user && user.is_password?(password) ? user : nil
  end
end
