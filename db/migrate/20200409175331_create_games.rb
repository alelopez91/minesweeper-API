class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.text :visible_grid, array: true, default: []
      t.text :mine_grid, array: true, default: []
      t.boolean :game_over, default: false

      t.timestamps
    end
  end
end
