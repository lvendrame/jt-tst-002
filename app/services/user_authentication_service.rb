
module UserAuthenticationService
  class HandleLoginFailure
    attr_reader :email, :error_message, :ip_address

    def initialize(email, error_message, ip_address)
      @email = email
      @error_message = error_message
      @ip_address = ip_address
    end

    def call
      return { status: 400, error: "Email is required." } if email.blank?
      return { status: 400, error: "Error message is required." } if error_message.blank?

      log_failed_attempt
      log_failed_login_attempt

      { status: 200, message: "Login failure recorded." }
    end

    private 

    def log_failed_attempt
      LoginFailure.create(email: email, error_message: error_message)
    end

    def log_failed_login_attempt
      user = User.find_by(email: email)
      LoginAttempt.create(
        user_id: user&.id,
        attempted_at: Time.current,
        success: false,
        ip_address: ip_address
      )
    end
  end

  class Authenticator
    def initialize(email, password, remember_me = false)
      @email = email
      @password = password
      @remember_me = remember_me
    end

    def authenticate_user
      return if email.blank? || password.blank?

      user = User.find_by(email: email)
      return unless user && user.valid_password?(password)

      user.update(
        session_token: SecureRandom.hex(10),
        session_expiration: determine_session_expiration(@remember_me)
      )

      user.session_token
    end

    private

    attr_reader :email, :password

    def determine_session_expiration(remember_me)
      remember_me ? 90.days.from_now : 24.hours.from_now
    end
  end
end
