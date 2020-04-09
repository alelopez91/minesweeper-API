require "rails_helper"

RSpec.describe Api::V1::GamesController, type: :request do

  context '#create' do
    it "creates a new game" do
      expect { post api_v1_games_path }.to change { Game.count }.by(1)
    end
  end

  context '#update' do
    context "When the game is over" do
      it 'returns unavailable game message' do
        game = FactoryBot.create(:game_lost)
        
        put api_v1_game_path(game.id), params: game_params(1, 1)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['msg']).to eq('Game ended. Cannot continue.')
      end
    end

    context "When the game is in progress" do
      it 'returns loss message' do
        game = FactoryBot.create(:game)
        
        put api_v1_game_path(game.id), params: game_params(1, 3)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['msg']).to eq('Game Over')
      end

      it 'returns win message' do
        game = FactoryBot.create(:game_almost_won)
        expect(game.game_over).to be(false)
        
        put api_v1_game_path(game.id), params: game_params(1, 10)

        expect(response).to have_http_status(200)
        expect(game.reload.game_over).to be(true)
        expect(JSON.parse(response.body)['msg']).to eq('You Won')
      end

      it 'returns valid movement message' do
        game = FactoryBot.create(:game)
        
        put api_v1_game_path(game.id), params: game_params(1, 10)

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['msg']).to eq('Next Movement')
      end
    end
  end

  private
  def game_params(x, y)
    {game: {x: x, y: y}}
  end
end
