# rubocop:disable Style/ClassAndModuleChildren
module StylistRequestService
  class Create
    def self.call(user_id:, stylist_id:, request_details:)
      user = User.find_by(id: user_id)
      stylist = User.find_by(id: stylist_id, is_stylist: true)

      if user.nil? || stylist.nil?
        return { error: 'Invalid user_id or stylist_id' }
      end

      request = StylistRequest.new(
        user_id: user_id,
        stylist_id: stylist_id,
        request_details: request_details,
        status: 'pending'
      )

      if request.save
        { message: 'Request sent successfully', request_id: request.id }
      else
        { error: request.errors.full_messages.to_sentence }
      end
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
