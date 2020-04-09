class GridGenerator
  BOARD_SIZE = 10
  TOTAL_CELLS = BOARD_SIZE * BOARD_SIZE
  MINE = 'X'
  MINE_FLAG = '?'
  UNKNOWN_CELL = 'U'
  SAFE_CELL = 'S'
  DIFFICULTY = 0.8 # between 0 and 1; the probability that the cell is not a mine.

  attr_reader :visible_grid, :mine_grid

  def initialize(visible_grid = nil, mine_grid = nil)
    @visible_grid = visible_grid || generate_clean_grid
    @mine_grid = mine_grid || generate_grid_with_mines(@visible_grid)
  end

  def generate_clean_grid
    Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, UNKNOWN_CELL) }
  end

  def generate_grid_with_mines(nested_array)
    mine_array = nested_array.map do |array|
      array.map do |cell|
        set_cell_status(generate_random_number) ? MINE : UNKNOWN_CELL
      end
    end
    mine_array
  end

  def untouched_cells
    @visible_grid.flatten.count(UNKNOWN_CELL)
  end

  def number_of_mines
    @mine_grid.flatten.count(MINE)
  end

  private

  def generate_random_number
    Random.new.rand(1...(TOTAL_CELLS))
  end

  def set_cell_status(random_number)
    mine_cutoff_point = TOTAL_CELLS * DIFFICULTY
    random_number > mine_cutoff_point
  end
end