require 'games_dice'

class GamesController < ApplicationController
    
    before_action :authenticate_user!

    def new
        @game = Game.new
    end

    def create
        @game = current_user.games.create(game_params.merge(player_1_id: current_user.id)
        .merge(current_status: "inactive").merge(current_user: current_user.id))
        
        redirect_to root_path
    end

    def index

    end
    
    def show
        @game = current_game
    end

    def roll
        dice = GamesDice.create '1d6'
        dice.roll
        puts "Result 1 is #{dice.result}"
        @result = dice.result
        dice.roll
        @result2 = dice.result
        respond_to do |format|
            format.js
        end
    end

    def forfeit
        @game = Game.find_by_id(params[:game_id])
        @game.update_attributes(loser_player_id: current_user.id)
        if @game.loser_player_id == @game.player_1_id
            @game.winner_player_id = @game.player_2_id
        else
            @game.winner_player_id = @game.player_1_id
        end
        @game.update_attributes(current_status: "inactive")
        redirect_to root_path
    end

    private
    
    def game_params
        params.require(:game).permit(:title, :email)
    end
    
    def current_game
        @game ||= Game.find(params[:id])
      end
    
end
