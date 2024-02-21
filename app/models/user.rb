
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  # Check if the user is a stylist
  def has_ongoing_authentication?
    !session_token.nil? && session_expiration > Time.current
  end

  def stylist?
    is_stylist
  end
end
