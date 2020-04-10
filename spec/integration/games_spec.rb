require 'swagger_helper'

describe 'Games API' do
  path 'api/v1/games' do
    post 'Creates a game' do
      produces 'application/json'

      response '200', 'Game started' do
        schema type: :object,
          properties: {
            msg: { type: :string },
            game: {type: :object,
              properties: {
                id: { type: :integer },
                visible_grid: { type: :string },
                mine_grid: { type: :string },
                game_over: { type: :boolean }
              }
            }
          }

        let(:game) { FactoryBot.create(:game) }
        run_test!
      end
    end
  end

  path 'api/v1/games/{id}' do
    get 'Retrieve game' do
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Game found' do
        schema type: :object,
          properties: {
            msg: { type: :string },
            game: {type: :object,
              properties: {
                id: { type: :integer },
                visible_grid: { type: :string },
                mine_grid: { type: :string },
                game_over: { type: :boolean }
              }
            }
          }

        let(:game) { FactoryBot.create(:game) }
        run_test!
      end

      response '404', 'Game not found' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path 'api/v1/games/{id}' do
    put 'Make a movement' do
      produces 'application/json'

      response '200', 'Game updated' do
        schema type: :object,
          properties: {
            msg: { type: :string },
            game: {type: :object,
              properties: {
                id: { type: :integer },
                visible_grid: { type: :string },
                mine_grid: { type: :string },
                game_over: { type: :boolean }
              }
            }
          }

        let(:game) { FactoryBot.create(:game) }
        run_test!
      end

      response '404', 'Game not found' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
