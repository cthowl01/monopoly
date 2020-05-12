# frozen_string_literal: true

# frozen_string_literal: true

Chat.setup do |config|
  # Clearance => :signed_in?
  # Devise    => :user_signed_in?
  config.signed_in = :user_signed_in?

  # Clearance => :require_login
  # Devise    => :authenticate_user!
  config.logged_in_check = :authenticate_user!

  config.user_avatar = :avatar

  config.perform_method = :perform_now
end
