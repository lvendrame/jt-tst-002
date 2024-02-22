# rubocop:disable Style/ClassAndModuleChildren
module StylistRequestService
  class Create
    def self.call(user_id:, stylist_id:, request_details:)
      user = User.find_by(id: user_id)      
      return { status: 400, error: I18n.t('activerecord.errors.messages.invalid_user_id') } if user.nil?

      stylist = User.find_by(id: stylist_id, is_stylist: true)
      return { status: 400, error: I18n.t('activerecord.errors.messages.invalid_stylist_id') } if stylist.nil?

      if request_details.blank?
        return { status: 400, error: I18n.t('activerecord.errors.messages.blank_request_details') }
      end

      request = StylistRequest.new(
        user_id: user_id,
        stylist_id: stylist_id,
        request_details: request_details,
        status: 'pending' # Assuming 'pending' is a valid status within the enum
      )

      if request.save
        { status: 200, message: 'Request sent successfully', request_id: request.id }
      else
        { status: 422, error: request.errors.full_messages.to_sentence }
      end
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
