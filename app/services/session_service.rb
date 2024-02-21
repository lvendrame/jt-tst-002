# frozen_string_literal: true

module Services
  class SessionService < BaseService
    def update_session_expiration(session_token:, maintain_session:)
      begin
        user = User.find_by!(session_token: session_token)

        new_expiration = maintain_session ? 90.days.from_now : 24.hours.from_now
        user.update!(session_expiration: new_expiration)

        { status: 200, message: 'Session expiration updated.', session_expiration: new_expiration }
      rescue ActiveRecord::RecordNotFound
        { status: 400, message: 'Session token not found.' }
      rescue StandardError => e
        logger.error "Failed to update session expiration: #{e.message}"
        { status: 500, message: 'Failed to update session expiration' }
      end
    end
  end
end

# Load the User model
require 'app/models/user.rb'

# Note: The User model is loaded automatically by Rails, so the require statement is not necessary.
# However, it is included here for clarity in case of manual loading requirements.
# The logger method is available from BaseService, which SessionService inherits from.
