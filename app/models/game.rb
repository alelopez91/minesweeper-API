class Game < ApplicationRecord
  def end
    update(game_over: true)
  end
end
