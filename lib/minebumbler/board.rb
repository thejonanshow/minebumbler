class Minebumbler::Board
  attr_reader :cells

  def initialize(difficulty = 5, randomize = true)
    rows, columns, mines = dimensions_for_difficulty(difficulty, randomize)
    cells_with_mines = generate_mines(rows, columns, mines)
    @cells = add_number_cells(cells_with_mines)
  end

  def generate_mines(rows, columns, mines)
    mine_cells = Array.new(mines) { "X" }
    empty_cells = Array.new((rows * columns) - mine_cells.length) { 0 }

    all_cells = (mine_cells + empty_cells).shuffle

    Array.new(rows) do
      all_cells.slice!(0..(columns - 1))
    end
  end

  def add_number_cells(cells_with_mines)
    surrounding = []

    cells_with_mines.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        if cell == "X"
          surrounding << surrounding_coordinates(row_index, column_index)
        end
      end
    end

    surrounding.flatten!(1)

    row_max    = cells_with_mines.length - 1
    column_max = cells_with_mines.first.length - 1

    surrounding.each do |row_index, column_index|
      next if (row_index < 0) || (column_index < 0)
      next if (row_index > row_max) || (column_index > column_max)
      next if cells_with_mines[row_index][column_index] == "X"

      cells_with_mines[row_index][column_index] += 1
    end

    cells_with_mines
  end

  def surrounding_coordinates(row, column)
    [
      [row - 1, column],
      [row + 1, column],
      [row, column - 1],
      [row, column + 1],
      [row - 1, column - 1],
      [row - 1, column + 1],
      [row + 1, column - 1],
      [row + 1, column + 1]
    ]
  end

  def dimensions_for_difficulty(difficulty, randomize)
    rows = columns = (7 + difficulty) unless randomize

    rows    ||= rand(5..(7 + difficulty))
    columns ||= rand(5..(7 + difficulty))

    size  = rows * columns
    maximum_mine_percentage = difficulty * 0.11

    maximum_mine_percentage = 0.8 if maximum_mine_percentage > 0.8

    minimum_mines = (size * 0.1).round
    maximum_mines = (size * maximum_mine_percentage).round

    mines = maximum_mines unless randomize
    mines ||= rand(minimum_mines..maximum_mines)

    [rows, columns, mines]
  end

  def raw
    lines = header

    cells.each_with_index do |row, index|
      lines << (index + 1).to_s.rjust(3) + "  |" + row.join(" ")
    end

    lines
  end

  def header
    column_labels = ("a".."z").to_a.slice(0..cells.first.length - 1)
    [ "      " + column_labels.join(" "), "     *" + ("-" * cells.first.length * 2) ]
  end

  def filtered
    lines = header

    cells.each_with_index do |row, index|
      lines << (index + 1).to_s.rjust(3) + "  |" + filtered_row(row)
    end

    lines
  end

  def filtered_row(row)
    ("%" * row.length).split(//).join(" ")
  end

end
