class Game < ApplicationRecord
    belongs_to :user

    has_many :properties
    has_many :user_games
    has_many :users, through: :user_games

    after_create :lay_out_board!

    def lay_out_board!

        Property.create(game_id: id, name: "Hard home", color: "brown", cost: 1, mortgage_cost: 1)
        
        Property.create(game_id: id, name: "Cave", color: "brown", cost: 1, mortgage_cost: 1)

        Property.create(game_id: id, name: "Yunkai", color: "aqua", cost: 1, mortgage_cost: 1)
        Property.create(game_id: id, name: "Astapor", color: "aqua", cost: 1, mortgage_cost: 1)
        Property.create(game_id: id, name: "Meereen", color: "aqua", cost: 1, mortgage_cost: 1)

        Property.create(game_id: id, name: "Horn hill", color: "magenta", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Oldtown", color: "magenta", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "High garden", color: "magenta", cost: 2, mortgage_cost: 1)

        Property.create(game_id: id, name: "Tower of Joy", color: "orange", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Water Gardens", color: "orange", cost: 2, mortgage_cost: 1)
        Property.create(game_id: id, name: "Sun spear", color: "orange", cost: 2, mortgage_cost: 1)

        Property.create(game_id: id, name: "The Twins", color: "red", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "Harren hall", color: "red", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "Riverrun", color: "red", cost: 3, mortgage_cost: 2)

        Property.create(game_id: id, name: "Pyke", color: "yellow", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "The Eyrie", color: "yellow", cost: 3, mortgage_cost: 2)
        Property.create(game_id: id, name: "Casterly Rock", color: "yellow", cost: 3, mortgage_cost: 2)

        Property.create(game_id: id, name: "Bear Island", color: "green", cost: 4, mortgage_cost: 2)
        Property.create(game_id: id, name: "Moat Cailin", color: "green", cost: 4, mortgage_cost: 2)
        Property.create(game_id: id, name: "Winter fell", color: "green", cost: 4, mortgage_cost: 2)

        Property.create(game_id: id, name: "Dragon stone", color: "purple", cost: 5, mortgage_cost: 3)
        Property.create(game_id: id, name: "Kings Landing", color: "purple", cost: 5, mortgage_cost: 3)

      end
end
