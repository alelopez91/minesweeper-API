class GameManager
  attr_reader :grid

  def initialize(grid)
    @grid = grid
    @safe_cells = []
  end

  def play_turn(x_coord, y_coord, game)
    guess = CoordinatePair.new(x_coord, y_coord)

    reveal_guess(guess, @grid.visible_grid)
    game.update(visible_grid: @grid.visible_grid)

    if mine?(guess)
      result = 'Game Over'
      game.end
    elsif won?
      result = 'You Won'
      game.end
    else
      result = 'Next Movement'
    end

    result
  end

  def won?
    untouched_cells = @grid.untouched_cells
    number_of_mines = @grid.number_of_mines
    untouched_cells == number_of_mines
  end

  def mine?(guess)
    coordinates = axis_adjusted_coordinates(guess)

    @grid.mine_grid[coordinates.y][coordinates.x] == GridGenerator::MINE
  end

  def reveal_guess(guess, grid)
    coordinates = axis_adjusted_coordinates(guess)
    number = number_of_surrounding_mines(coordinates)

    if mine?(guess)
      grid[coordinates.y][coordinates.x] = GridGenerator::MINE
    elsif number == 0
      grid[coordinates.y][coordinates.x] = GridGenerator::SAFE_CELL
      @safe_cells.push(coordinates)
      show_empty_neighbours(coordinates)
    else
      grid[coordinates.y][coordinates.x] = number
    end
  end

  private

  def axis_adjusted_coordinates(guess)
    x_value = guess.x - 1
    y_value = GridGenerator::BOARD_SIZE - (guess.y) # because counting from bottom rather than top
    return CoordinatePair.new(x_value, y_value)
  end

  def number_of_surrounding_mines(guess)
    cell_coords = get_surrounding_cell_coords(guess)
    cell_values = get_surrounding_cell_values(cell_coords)
    cell_values.count(GridGenerator::MINE)
  end

  def get_surrounding_cell_values(array_of_cell_coords)
    cell_values = []

    array_of_cell_coords.each do |cell|
      cell_values.push(@grid.mine_grid[cell.y][cell.x])
    end

    return cell_values
  end

  def get_surrounding_cell_coords(coordinates)
    surrounding_cell_coords = []

    # up
    if coordinates.y >= 1
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x, coordinates.y - 1))
    end

    # down
    if coordinates.y < GridGenerator::BOARD_SIZE - 1
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x, coordinates.y + 1))
    end

    # left
    if coordinates.x >= 1
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y))
    end

    # right
    if coordinates.x < GridGenerator::BOARD_SIZE - 1
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y))
    end

    # top left
    if coordinates.y >= 1 && coordinates.x >= 1
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y - 1))
    end

    # bottom left
    if coordinates.y < GridGenerator::BOARD_SIZE - 1 && coordinates.x >= 1
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y + 1))
    end

    # top right
    if coordinates.y >= 1 && coordinates.x < GridGenerator::BOARD_SIZE - 1
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y - 1))
    end

    # bottom right
    if coordinates.y < GridGenerator::BOARD_SIZE - 1 && coordinates.x < GridGenerator::BOARD_SIZE - 1
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y + 1))
    end

    return surrounding_cell_coords
  end

  def show_empty_neighbours(cell)
    neighbour_cells = get_surrounding_cell_coords(cell)

    neighbour_cells.each do |cell|
      if @safe_cells.include?(cell)
        next
      end

      reveal_neighbours_on_board(cell)
    end
  end

  def reveal_neighbours_on_board(cell)
    cell_value = number_of_surrounding_mines(cell)

    if cell_value == 0
      @safe_cells.push(cell)
      @grid.visible_grid[cell.y][cell.x] = GridGenerator::SAFE_CELL
      show_empty_neighbours(cell)
    else
      @grid.visible_grid[cell.y][cell.x] = cell_value
    end
  end

  def number?(input)
    input.to_i != 0
  end

  def number_in_range?(input)
    input.to_i.between?(1, GridGenerator::BOARD_SIZE)
  end
end