module Api
  class StylistRequestsController < BaseController
    before_action :doorkeeper_authorize!

    def create
      result = StylistRequestService::Create.call(
        user_id: params[:user_id],
        stylist_id: params[:stylist_id],
        request_details: params[:request_details]
      )

      if result[:error].present?
        render json: { error: result[:error] }, status: :unprocessable_entity
      else
        render json: {
          status: 200,
          message: result[:message],
          request_id: result[:request_id]
        }, status: :ok
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end
  end
end
