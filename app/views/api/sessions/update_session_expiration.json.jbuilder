json.status 200
json.message "Session expiration updated."
json.session_expiration (Time.current + 2.hours).utc.iso8601
