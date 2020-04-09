module Api
  module V1
    class GamesController < ApplicationController
      def create
        render json: { msg: 'Games#create' }, status: :ok, adapter: :json
      end

      def update
        render json: { msg: 'Games#update' }, status: :ok, adapter: :json
      end
    end
  end
end
