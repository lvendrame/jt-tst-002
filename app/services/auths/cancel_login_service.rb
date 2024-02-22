
# frozen_string_literal: true

module Auths
  class CancelLoginService
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def cancel
      user = User.find_by(id: user_id)
      return { error: 'User not found.', status: 404 } unless user

      if ongoing_authentication?(user)
        terminate_authentication_process(user)
        log_cancellation_event(user)
        { success: true, message: 'Login process cancelled successfully' }
      else
        { error: 'No ongoing authentication process found.', status: 422 }
      end
    end

    private

    def ongoing_authentication?(user)
      user.session_token.present? && user.session_expiration > Time.current
    end

    def terminate_authentication_process(user)
      user.update(session_token: nil, session_expiration: Time.current)
    end

    def log_cancellation_event(user)
      # Logic to log the cancellation event for the given user
      # This could be writing to a log file or creating an audit record in the database
      # Placeholder for actual implementation
    end
  end
end
