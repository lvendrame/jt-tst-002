module UserAuthenticationService
  class HandleLoginFailure
    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      return { error: I18n.t('activerecord.errors.messages.blank') } if email.blank? || password.blank?

      user = User.find_by(email: email)
      if user.nil?
        log_failed_attempt
        return { error: I18n.t('devise.failure.not_found_in_database', authentication_keys: 'Email') }
      end

      unless user.valid_password?(password)
        log_failed_attempt
        return { error: I18n.t('devise.failure.invalid', authentication_keys: 'Email') }
      end
    end

    private

    attr_reader :email, :password

    def log_failed_attempt
      # Log the failed login attempt here
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
