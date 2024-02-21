# typed: ignore
module Api
  class SessionsController < BaseController
    def cancel_login
      cancel_service = Auths::CancelLoginService.new
      result = cancel_service.cancel
      render json: result, status: result[:success] ? :ok : :unprocessable_entity
    end

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
  end
end

