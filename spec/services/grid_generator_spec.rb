require 'rails_helper'

RSpec.describe 'GridGenerator' do
  context 'When creating' do
    it 'generates a new grid' do
      grid = GridGenerator.new

      expect(grid.visible_grid).not_to be_empty
      expect(grid.mine_grid).not_to be_empty
    end

    it 'doesnt generates a new grid and receives a previous one' do
      game = FactoryBot.create(:game)
      grid = GridGenerator.new(game.visible_grid, game.mine_grid)

      expect(grid.visible_grid).to eq(game.visible_grid)
      expect(grid.mine_grid).to eq(game.mine_grid)
    end

    it 'generates a 10x10 grid' do
      grid = GridGenerator.new

      expect(grid.visible_grid.flatten.count).to eq(GridGenerator::TOTAL_CELLS)
    end
  end
end
