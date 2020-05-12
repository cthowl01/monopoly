class Property < ApplicationRecord
    belongs_to :user, required: false
    belongs_to :game
end
