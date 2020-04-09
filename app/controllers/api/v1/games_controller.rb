module Api
  module V1
    class GamesController < ApplicationController
      def create
        @game_manager = GameManager.new
        @grid = @game_manager.grid

        game = Game.new(visible_grid: @grid.visible_grid, mine_grid: @grid.mine_grid)

        if game.save
          render json: { msg: 'Game started', game: game }, status: :ok, adapter: :json
        else
          render json: { msg: game.errors, game: game }, status: :bad_request, adapter: :json
        end

      end

      def update
        render json: { msg: 'Games#update' }, status: :ok, adapter: :json
      end
    end
  end
end
