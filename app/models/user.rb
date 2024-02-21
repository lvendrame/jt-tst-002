
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  # Check if the user is a stylist
  def stylist?
    is_stylist
  end
end
