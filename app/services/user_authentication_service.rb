
module UserAuthenticationService
  class HandleLoginFailure
    def initialize(email, error_message)
      @email = email
      @error_message = error_message
    end

    def call
      return { status: 400, error: "Email is required." } if email.blank?
      return { status: 400, error: "Error message is required." } if error_message.blank?

      log_failed_attempt

      { status: 200, message: "Login failure recorded." }
    end

    private

    attr_reader :email, :error_message

    # Log the failed login attempt here
    def log_failed_attempt
      # Assuming there is a model called LoginFailure to record login failures
      LoginFailure.create(email: email, error_message: error_message)
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
