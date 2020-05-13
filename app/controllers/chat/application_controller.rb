# frozen_string_literal: true

module Chat
  class ApplicationController < ::ApplicationController
    #helper Rails.application.routes.url_helpers
    #skip_before_action :verify_authenticity_token
    #protect_from_forgery with: :null_session

    #before_action Chat.logged_in_check

  end
end
