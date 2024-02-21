
class Api::PasswordResetsController < ApplicationController
  # POST /api/password_resets
  def create
    email = params[:email].to_s

    if email.blank? 
      return render json: { error: I18n.t('activerecord.errors.messages.blank') }, status: :unprocessable_entity
    end

    user = UserService.new.find_user_by_email(email)
    if user.nil?
      return render json: { error: 'Email not found.' }, status: :unprocessable_entity
    end

    password_reset_request = PasswordResetService.new(user.email).create_password_reset_request
    if password_reset_request.nil?
      return render json: { error: 'Failed to create password reset request.' }, status: :internal_server_error
    end

    EmailService.new.send_password_reset_email(user, password_reset_request.token)

    render json: {
      status: 200,
      message: 'Password reset request sent successfully.',
      reset_token: password_reset_request.token
    }, status: :ok
  end
end
