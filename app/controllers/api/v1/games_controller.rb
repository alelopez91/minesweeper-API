module Api
  module V1
    class GamesController < ApplicationController
      before_action :set_game, only: [:update, :show]

      def create
        @grid = GridGenerator.new
        @game_manager = GameManager.new(@grid)

        game = Game.new(visible_grid: @grid.visible_grid, mine_grid: @grid.mine_grid)

        if game.save
          render json: { msg: 'Game started', game: game }, status: :ok, adapter: :json
        else
          render json: { msg: game.errors, game: game }, status: :bad_request, adapter: :json
        end

      end

      def update
        if @game.game_over?
          message = 'Game ended. Cannot continue.'
        else
          @grid = GridGenerator.new(@game.visible_grid, @game.mine_grid)

          x = game_params[:x]
          y = game_params[:y]

          @game_manager = GameManager.new(@grid)
          message = @game_manager.play_turn(x, y, @game)
        end

        render json: { msg: message, game: @game }, status: :ok, adapter: :json
      end

      def show
        render json: { msg: 'Game Found', game: @game }, status: :ok, adapter: :json
      end

      private

      def game_params
        params.require(:game).permit(:x, :y)
      end

      def set_game
        @game = Game.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Game Not Found' }, status: :not_found, adapter: :json
      end
    end
  end
end
