class Game < ApplicationRecord
    scope :available, -> { Game.where(player_1_id: [nil, ""]).or(Game.where(player_2_id: [nil, ""])) }
    scope :active, -> { Game.where(current_status: "active") }

    belongs_to :user

    has_many :properties
    has_many :user_games
    has_many :users, through: :user_games
    has_many :moves

    after_create :lay_out_board!

    def lay_out_board!

        Property.create(game_id: id, name: "Start", div_id: 0, property_type: "square")
        Property.create(game_id: id, name: "Hard home", div_id: 1, color: "brown", cost: 1, mortgage_cost: 1)
        Property.create(game_id: id, name: "Chance", div_id: 2, property_type: "chance")
        Property.create(game_id: id, name: "Cave", div_id: 3, color: "brown", cost: 1, mortgage_cost: 1)
        Property.create(game_id: id, name: "Dothraki Tribute", div_id: 4, property_type: "penalty")
        Property.create(game_id: id, name: "The Old Gods", div_id: 5, color: "black", property_type: "faith", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Yunkai", div_id: 6, color: "powderblue", cost: 1, mortgage_cost: 1)
        Property.create(game_id: id, name: "Chance", div_id: 7, property_type: "chance")
        Property.create(game_id: id, name: "Astapor", div_id: 8, color: "powderblue", cost: 1, mortgage_cost: 1)
        Property.create(game_id: id, name: "Meereen", div_id: 9, color: "powderblue", cost: 1, mortgage_cost: 1)
        Property.create(game_id: id, name: "Jail", div_id: 10, property_type: "square")
        Property.create(game_id: id, name: "Horn hill", div_id: 11, color: "magenta", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Citadel of Maestors", div_id: 12, property_type: "offer", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Oldtown", div_id: 13, color: "magenta", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "High garden", div_id: 14, color: "magenta", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Many Faced God", div_id: 15, color: "black", property_type: "faith", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Tower of Joy", div_id: 16, color: "orange", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Chance", div_id: 17, property_type: "chance")
        Property.create(game_id: id, name: "Water Gardens", div_id: 18, color: "orange", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Sun spear", div_id: 19, color: "orange", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Free Parking", div_id: 20, property_type: "square")
        Property.create(game_id: id, name: "The Twins", div_id: 21, color: "red", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "Chance", div_id: 22, property_type: "chance")
        Property.create(game_id: id, name: "Harren hall", div_id: 23, color: "red", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "Riverrun", div_id: 24, color: "red", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "Lord of Light", div_id: 25, color: "black", property_type: "faith", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Pyke", div_id: 26, color: "yellow", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "The Eyrie", div_id: 27, color: "yellow", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "Castle Black", div_id: 28, property_type: "offer", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Casterly Rock", div_id: 29, color: "yellow", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "Go To Jail", div_id: 30, property_type: "square")
        Property.create(game_id: id, name: "Bear Island", div_id: 31, color: "green", cost: 4, mortgage_cost: 2)
        Property.create(game_id: id, name: "Moat Cailin", div_id: 32, color: "green", cost: 4, mortgage_cost: 2)
        Property.create(game_id: id, name: "Chance", div_id: 33, property_type: "chance")
        Property.create(game_id: id, name: "Winter fell", div_id: 34, color: "green", cost: 4, mortgage_cost: 2)
        Property.create(game_id: id, name: "The Seven", div_id: 35, color: "black", property_type: "faith", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Chance", div_id: 36, property_type: "chance")
        Property.create(game_id: id, name: "Dragon stone", div_id: 37, color: "purple", cost: 5, mortgage_cost: 3)
        Property.create(game_id: id, name: "Iron Bank", div_id: 38, property_type: "penalty")
        Property.create(game_id: id, name: "Kings Landing", div_id: 39, color: "purple", cost: 5, mortgage_cost: 3)
      end

      def refresh_firebase

        firebase_url    = 'https://fir-chess-270721.firebaseio.com/';
        firebase_secret = '8g8o1V0UsNy7O1I4kcRXlClM8vo4V4Yi44pQOLqt';
        firebase = Firebase::Client.new(firebase_url, firebase_secret)

        puts "firebase is #{firebase}"

        path = "mgames/" + self.firebase_id

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
          
      end

      def toggle_player_turn
        if self.turn_player_id == self.player_1_id
          self.update_attributes(turn_player_id: self.player_2_id)
          usergame = UserGame.find_by(game_id: self.id, user_id: self.player_1_id)
          usergame.update_attributes(num_moves: usergame.num_moves + 1)
        else
          self.update_attributes(turn_player_id: self.player_1_id)
          usergame = UserGame.find_by(game_id: self.id, user_id: self.player_2_id)
          usergame.update_attributes(num_moves: usergame.num_moves + 1)
        end
      end

      def player_1
        User.find_by_id(player_1_id)
      end
    
      def player_2
        User.find_by_id(player_2_id)
      end
    
      def winner
        User.find_by_id(winner_player_id)
      end
    
      def loser
        User.find_by_id(loser_player_id)
      end

      def which_player
        if self.turn_player_id == self.player_1_id
          return 1
        else
          return 2
        end

      end

      
end
