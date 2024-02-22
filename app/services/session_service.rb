# frozen_string_literal: true

module Services
  class SessionService < BaseService
    def update_session_expiration(session_token:, maintain_session:)
      # Receive the "session_token" from the request.
      begin
        user = User.find_by(session_token: session_token)

        if user && user.session_expiration > Time.current
          # If the session is valid and the user is not a stylist, extend the "session_expiration".
          if !user.stylist? && maintain_session
            new_expiration = 90.days.from_now
            user.update(session_expiration: new_expiration)
          end

          { status: 200, message: 'Session has been maintained.', session_expiration: user.session_expiration }
        else
          { status: 400, message: 'Invalid or expired session token.' }
        end
      rescue ActiveRecord::RecordNotFound
        { status: 404, message: 'Session token not found.' }
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
