# app/services/user_authentication_service.rb
class UserAuthenticationService
  def initialize(email, password)
    @email = email
    @password = password
  end

  def authenticate_user
    return if email.blank? || password.blank?

    user = User.find_by(email: email)
    return unless user && user.password_hash == Digest::SHA256.hexdigest(password)

    user.update(
      session_token: SecureRandom.hex(10),
      session_expiration: determine_session_expiration(remember_me)
    )

    user.session_token
  end

  private

  attr_reader :email, :password

  def determine_session_expiration(remember_me)
    remember_me ? 90.days.from_now : 24.hours.from_now
  end
end
