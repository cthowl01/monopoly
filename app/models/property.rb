class Property < ApplicationRecord
    belongs_to :user, required: false
    belongs_to :game


    def is_set_owned_by(owner_id)
        if game.properties.where(color: self.color, owner_id: owner_id).count == 
            game.properties.where(color: self.color).count
            return true
        else
            return false
        end
    end
end


