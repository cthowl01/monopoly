class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
        @games = Game.all
        @current_user = current_user
    end

    def load_active
        @games = Game.all
    
        respond_to do |format|
          format.js
        end
    
      end
    
    def load_available
        @games = Game.all
        @current_user = current_user

        respond_to do |format|
            format.js
        end

    end
end
