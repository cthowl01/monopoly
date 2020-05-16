class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def toggle_show_rolls
    otheruserid = game.users.where.not(id: user.id).first.id
    otherusergame = UserGame.find_by(game_id: game.id, user_id: otheruserid )

    if game.turn_player_id == user.id
      self.update_attributes(show_roll: false)
      otherusergame.update_attributes(show_roll: true)
    else
      self.update_attributes(show_roll: true)
      otherusergame.update_attributes(show_roll: false)
    end
  end

  


  def calculate_new_position(result)
    new_position = self.position + result
    if new_position >= 40
      new_position = new_position - 40
      self.update_attributes(balance: self.balance+2)
    elsif new_position < 0
      new_position = new_position + 40
    end
    return new_position
  end

  def calculate_rent(prop_id)

    property = game.properties.find_by(div_id: prop_id)

    rent = property.cost

    if property.hotels != 0 
      return rent * 10
    end

    if property.houses != 0 
      return rent * ((property.houses - 1) + 3)
    end

    if game.properties.where(color: property.color, owner_id: user.id).count == 
      game.properties.where(color: property.color).count
      if property.property_type == "regular"
        return rent * 2
      end
    end

    if property.property_type == "offer"
      otheruserid = game.users.where.not(id: user.id).first.id
      otherusergame = UserGame.find_by(game_id: game.id, user_id: otheruserid )
      if game.properties.where(property_type: "offer", owner_id: user.id).count == 2
        return (otherusergame.last_roll[0] + otherusergame.last_roll[1])
      else 
        return (otherusergame.last_roll[0] + otherusergame.last_roll[1]) / 2
      end
    end

    if property.property_type == "faith"
      return 2 * game.properties.where(color: "black", owner_id: user.id).count
    end

    puts "Rent is #{rent}"

    return rent
  end

end
