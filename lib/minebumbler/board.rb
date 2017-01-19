class Minebumbler::Board
  attr_reader :cells

  def initialize(difficulty = 5, randomize = true)
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

    cells_with_mines = generate_mines(rows, columns, mines)

    @cells = add_number_cells(cells_with_mines)

    @cells = cells_with_mines
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
    rows = cells_with_mines.length - 1
    columns = cells_with_mines.first.length - 1

    coords = []

    cells_with_mines.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        if cell == "X"
          coords.push([row_index - 1, column_index]) if row_index > 0          #N
          coords.push([row_index + 1, column_index]) if row_index < rows       #S
          coords.push([row_index, column_index - 1]) if column_index > 0       #E
          coords.push([row_index, column_index + 1]) if column_index < columns #W

          coords.push([row_index - 1, column_index - 1]) if (row_index > 0) && (column_index > 0)          #NW
          coords.push([row_index - 1, column_index + 1]) if (row_index > 0) && (column_index < columns)    #NE
          coords.push([row_index + 1, column_index - 1]) if (row_index < rows) && (column_index > 0)       #SW
          coords.push([row_index + 1, column_index + 1]) if (row_index < rows) && (column_index < columns) #SE
        end
      end
    end

    coords.each do |row_index, column_index|
      unless cells_with_mines[row_index][column_index] == "X"
        cells_with_mines[row_index][column_index] += 1
      end
    end

    cells_with_mines
  end

  def raw
    @cells.map do |row|
      row.join(" ")
    end.join("\n")
  end
end
