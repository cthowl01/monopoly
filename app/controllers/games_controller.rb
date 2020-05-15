require 'games_dice'
require "firebase"

class GamesController < ApplicationController
    
    before_action :authenticate_user!
    before_action :get_common_variables, except: [:index, :new, :create]
    before_action :get_property, except: [:index, :new, :create, :update, :roll]
    
    def new
        @game = Game.new
    end

    def create
        @game = current_user.games.create(game_params.merge(player_1_id: current_user.id)
        .merge(current_status: "inactive").merge(current_user: current_user.id))

        @user = User.find(current_user.id)

        @game.users << User.find(current_user.id)

        @game.user_ids << @game.player_1_id

        @user.games << @game

        @user.game_ids << @game.id

        firebase_id = @game.title
        data = {
            refresh: false
        }
        
        firebase_url    = 'https://fir-chess-270721.firebaseio.com/';
        firebase_secret = '8g8o1V0UsNy7O1I4kcRXlClM8vo4V4Yi44pQOLqt';
        firebase = Firebase::Client.new(firebase_url, firebase_secret)

        path = "mgames";
        
        response = firebase.push(path, {
            :name => firebase_id,
            :refresh => false,
            :created => Firebase::ServerValue::TIMESTAMP
          })

        puts "Firebase ID is " + response.body["name"];

        @game.update_attributes(firebase_id: response.body["name"]);

        redirect_to games_path
    end

    def index
        @games = Game.all
    end

    def update
            @game = current_game

            @user = User.find(current_user.id)

            @game.users << @user
            
            @game.user_ids << current_user.id
            
            @user.games << @game

            @user.game_ids << @game.id

            @game.update_attributes(turn_player_id: @game.player_1_id)
            @game.update_attributes(player_2_id: current_user.id)
            @game.update_attributes(current_status: "active")

            @usergame = UserGame.find_by(game_id: @game.id, user_id: current_user.id)

            @usergame.update_attributes(piece: "hat_piece.png")

            redirect_to game_path(@game)
    end
    
    def show
        
    end

    def roll
        @user = User.find_by_id(current_user.id)

        @usergame.last_roll = []
        dice = GamesDice.create '1d6'
        dice.roll
        @result = dice.result
        @usergame.last_roll << dice.result

        dice.roll
        @result2 = dice.result
        @usergame.last_roll << dice.result

        @usergame.update_attributes(previous_position: @usergame.position)

        @usergame.update_attributes(position: @usergame.calculate_new_position(@result + @result2))

        firebase_url    = 'https://fir-chess-270721.firebaseio.com/';
        firebase_secret = '8g8o1V0UsNy7O1I4kcRXlClM8vo4V4Yi44pQOLqt';
        firebase = Firebase::Client.new(firebase_url, firebase_secret)

        puts "firebase is #{firebase}"

        path = "mgames/" + @game.firebase_id

        puts "Before firebase"

        refreshVal = firebase.get(path + "/refresh")

        if refreshVal.body == true
            puts "Firebase set to false"
            response = firebase.update(path, {
                :refresh => false
            })
        else
            puts "Firebase set to true"
            response = firebase.update(path, {
                :refresh => true
                })
        end
            
        if @result != @result2
            @usergame.toggle_show_rolls
        elsif @usergame.jail != true
            @usergame.update_attributes(num_double_rolls: @usergame.num_double_rolls+1)
        end

        @usergame.update_attributes(show_buttons: true)

        @property = @game.properties.find_by(div_id: @usergame.position)

        respond_to do |format|
            format.js
        end
    end

    def forfeit
        @game = current_game
        @game.update_attributes(loser_player_id: current_user.id)
        if @game.loser_player_id == @game.player_1_id
            @game.winner_player_id = @game.player_2_id
        else
            @game.winner_player_id = @game.player_1_id
        end
        @game.update_attributes(current_status: "inactive")
        redirect_to games_path
    end

    def move
        respond_to do |format|
          format.html
          format.js
        end
    end

    def pay_rent

        @owner = User.find_by_id(@property.owner_id)

        @ownerusergame = UserGame.find_by(game_id: params[:id], user_id: @property.owner_id)

        @rent = @ownerusergame.calculate_rent(@property.div_id)

        if @usergame.balance >= @rent
            @usergame.update_attributes(balance: @usergame.balance - @rent)
            @ownerusergame.update_attributes(balance: @ownerusergame.balance + @rent)
        else
            flash.now[:notice] = "Insufficient funds"
        end
        
        flash.now[:notice] = "A Lannister always pays his debts."

        if @usergame.last_roll[0] != @usergame.last_roll[1]
            @usergame.update_attributes(show_buttons: false)
            @game.toggle_player_turn
        end

        @game.refresh_firebase

        respond_to do |format|
          format.js
        end
    end

    def purchase
    
        if @usergame.balance >= @property.cost
            @usergame.update_attributes(balance: @usergame.balance - @property.cost)
            @property.update_attributes(owner_id: current_user.id)
        else
            flash.now[:notice] = "Insufficient funds"
        end
    
        if @usergame.last_roll[0] != @usergame.last_roll[1]
            @usergame.update_attributes(show_buttons: false)
            @game.toggle_player_turn
        end

        @game.refresh_firebase

        respond_to do |format|
            format.js
        end

    end

    def pass
        
        if @usergame.last_roll[0] != @usergame.last_roll[1]
            @usergame.update_attributes(show_buttons: false)
            @game.toggle_player_turn
        end

        @game.refresh_firebase

        respond_to do |format|
            format.js
        end
    end

    def penalty

        if @usergame.balance >= 2
            @usergame.update_attributes(balance: @usergame.balance - 2)
        else
            flash.now[:notice] = "You're broke!"
        end
    
        if @usergame.last_roll[0] != @usergame.last_roll[1]
            @usergame.update_attributes(show_buttons: false)
            @game.toggle_player_turn
        end

        @game.save
        
        flash.now[:notice] = "A Lannister always pays his debts."

        @game.refresh_firebase

        respond_to do |format|
            format.js
        end
    end

    def mortgage

        mortgaged_property = params[:mortgage_id]

        @property = @game.properties.find_by(div_id: mortgaged_property)
    
        if @property.owner_id == current_user.id 
            @usergame.update_attributes(balance: @usergame.balance + @property.mortgage_cost)
            @property.update_attributes(mortgaged: true)
        end 

        @game.refresh_firebase

        respond_to do |format|
            format.js
        end

    end

    def unmortgage

        mortgaged_property = params[:mortgage_id]

        @property = @game.properties.find_by(div_id: mortgaged_property)
    
        if @property.owner_id == current_user.id 
            @usergame.update_attributes(balance: @usergame.balance - @property.mortgage_cost)
            @property.update_attributes(mortgaged: false)
        end

        @game.refresh_firebase

        respond_to do |format|
            format.js
        end

    end

    def house

        house_property = params[:house_id]

        @property = @game.properties.find_by(div_id: house_property)

        if @property.houses < 4
            @property.update_attributes(houses: @property.houses + 1)
        else
            @property.update_attributes(houses: 0)
            @property.update_attributes(hotels: 1)
        end

        owner_id = @property.owner_id

        ownerusergame = UserGame.find_by(user_id: owner_id, game_id: current_game.id)

        ownerusergame.update_attributes(balance: ownerusergame.balance - @property.cost)

        @game.refresh_firebase

        respond_to do |format|
            format.js
        end

    end

    def chance

        if @usergame.last_roll[0] != @usergame.last_roll[1]
            @usergame.update_attributes(show_buttons: false)
            @game.toggle_player_turn
        end

        @game.refresh_firebase

        respond_to do |format|
            format.js
        end

    end

    def jail

        @usergame.update_attributes(jail: true, position: 10, num_double_rolls: 0)

        if @usergame.last_roll[0] != @usergame.last_roll[1]
            @usergame.update_attributes(show_buttons: false)
            @game.toggle_player_turn
        end

        @game.refresh_firebase

        respond_to do |format|
            format.js
        end

    end

    def load_board
        
        respond_to do |format|
            format.js
        end
    end

    def update_piece

        piece_url = params[:piece] + "_piece.png"

        respond_to do |format|
            format.js
        end

    end

    private

    def get_common_variables
        @game = current_game

        @usergame = UserGame.find_by(game_id: params[:id], user_id: current_user.id)

        @user_id1 = @game.player_1_id

        @user_id2 = @game.player_2_id

        @usergame1 = UserGame.find_by(user_id: @game.player_1_id, game_id: current_game.id)
        @usergame2 = UserGame.find_by(user_id: @game.player_2_id, game_id: current_game.id)
    end

    def get_property
        @usergame = UserGame.find_by(game_id: params[:id], user_id: current_user.id)

        @property = @game.properties.find_by(div_id: @usergame.position)
    end
    
    def game_params
        params.require(:game).permit(:title, :email)
    end
    
    def current_game
        @game ||= Game.find(params[:id])
    end
    
end
