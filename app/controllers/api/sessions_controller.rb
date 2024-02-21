# typed: ignore
module Api
  class SessionsController < BaseController
    def cancel_login
      cancel_service = Auths::CancelLoginService.new
      result = cancel_service.cancel
      render json: result, status: result[:success] ? :ok : :unprocessable_entity
    end
  end
end

