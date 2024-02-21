# typed: ignore
module Api
  class SessionsController < BaseController
    before_action :authorize_request, only: [:update_session_expiration]
    before_action :authenticate_user!, only: [:cancel_login]

    def create
      email = params[:email]
      password = params[:password]
      recaptcha = params[:recaptcha]

      if email.blank?
        return render json: { error: "Email is required." }, status: :unprocessable_entity
      elsif !User.email_valid?(email)
        return render json: { error: "Invalid email format." }, status: :unprocessable_entity
      elsif password.blank?
        return render json: { error: "Password is required." }, status: :unprocessable_entity
      elsif recaptcha.blank?
        return render json: { error: "Recaptcha is required." }, status: :unprocessable_entity
      end

      authenticator = UserAuthenticationService::Authenticator.new(email, password)
      session_token = authenticator.authenticate_user

      if session_token
        session_service = Services::SessionService.new
        session_service.update_session_expiration(session_token: session_token, maintain_session: false)

        render json: {
          status: 200,
          message: "Login successful.",
          session_token: session_token,
          session_expiration: User.find_by(email: email).session_expiration
        }, status: :ok
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    def update_session_expiration
      session_token = params[:session_token]
      maintain_session = params[:maintain_session]

      unless session_token
        return render json: { error: 'Session token not found.' }, status: :unprocessable_entity
      end

      unless [true, false].include?(maintain_session)
        return render json: { error: 'Maintain session must be a boolean.' }, status: :unprocessable_entity
      end

      service = Services::SessionService.new
      message = service.update_session_expiration(session_token: session_token, maintain_session: maintain_session)
      user = User.find_by(session_token: session_token)
      render json: { status: 200, message: message, session_expiration: user.session_expiration }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def cancel_login
      user_id = params.require(:user_id)

      unless User.exists?(user_id)
        render json: { error: I18n.t('activerecord.errors.messages.invalid_user_id') }, status: :unprocessable_entity
        return
      end

      cancel_service = Auths::CancelLoginService.new
      result = cancel_service.cancel
      render json: result, status: result[:success] ? :ok : :unprocessable_entity
    end

    private

    def authenticate_user!
      # Assuming there is a method to authenticate the user
      # Placeholder for actual implementation
    end

    def authorize_request
      # Assuming there is a method to authorize the request
      # Placeholder for actual implementation
    end
  end
end
