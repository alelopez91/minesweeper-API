require 'rails_helper'

RSpec.describe 'GameManager' do
  context 'When playing a turn' do
    let(:game) { FactoryBot.create(:game) }

    it 'updates the game visible grid' do
      old_visible_grid = game.visible_grid
      grid = GridGenerator.new(game.visible_grid, game.mine_grid)

      GameManager.new(grid).play_turn(1, 10, game)

      expect(game.reload.visible_grid).not_to eq(old_visible_grid)
    end

    context 'And losing the game' do
      it 'returns loss message' do
        grid = GridGenerator.new(game.visible_grid, game.mine_grid)

        message = GameManager.new(grid).play_turn(1, 3, game)

        expect(message).to eq('Game Over')
      end

      it 'ends the game instance' do
        grid = GridGenerator.new(game.visible_grid, game.mine_grid)

        expect(game.game_over).to eq(false)

        GameManager.new(grid).play_turn(1, 3, game)

        expect(game.game_over).to eq(true)
      end
    end

    context 'And winning the game' do
      let(:game_almost_won) { FactoryBot.create(:game_almost_won) }

      it 'returns win message' do
        grid = GridGenerator.new(game_almost_won.visible_grid, game_almost_won.mine_grid)

        message = GameManager.new(grid).play_turn(1, 10, game_almost_won)

        expect(message).to eq('You Won')
      end

      it 'ends the game instance' do
        grid = GridGenerator.new(game_almost_won.visible_grid, game_almost_won.mine_grid)

        expect(game_almost_won.game_over).to eq(false)

        GameManager.new(grid).play_turn(1, 10, game_almost_won)

        expect(game_almost_won.game_over).to eq(true)
      end
    end

    context 'And making a valid movement' do
      it 'returns valid movement message' do
        grid = GridGenerator.new(game.visible_grid, game.mine_grid)

        message = GameManager.new(grid).play_turn(1, 10, game)

        expect(message).to eq('Next Movement')
      end

      it 'does not end the game instance' do
        grid = GridGenerator.new(game.visible_grid, game.mine_grid)

        GameManager.new(grid).play_turn(1, 10, game)

        expect(game.game_over).to eq(false)
      end
    end
  end
end
