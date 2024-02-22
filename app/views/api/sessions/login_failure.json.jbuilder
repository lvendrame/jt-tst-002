json.status @status_code

json.ip_address @ip_address if @ip_address.present?
if @error_message.present?
  json.error @error_message
else
  json.message "Login failure recorded."
end
