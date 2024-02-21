if @error_message.present?
  json.error @error_message
else
  json.status 200
  json.message "Request sent successfully."
  json.request_id @stylist_request.id
end
