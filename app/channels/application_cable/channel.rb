module ApplicationCable
  class Channel < ActionCable::Channel::Base
    identified_by :current_user
  end
end
