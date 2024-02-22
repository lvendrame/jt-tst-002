json.status @status_code

if @error_message.present?
  json.error @error_message
else
  json.message "Login failure recorded."
end
