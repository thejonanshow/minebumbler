require "spec_helper"

describe Minebumbler::Board do
  context "#new" do
    it "creates an easy board" do
      board = Minebumbler::Board.new(1, false)
      mine_count = board.cells.flatten.count("X")
      expect(mine_count).to eql(7)
    end

    it "creates an intermediate board" do
      board = Minebumbler::Board.new(5, false)
      mine_count = board.cells.flatten.count("X")
      expect(mine_count).to eql(79)
    end

    it "creates a hard board" do
      board = Minebumbler::Board.new(10, false)
      mine_count = board.cells.flatten.count("X")
      expect(mine_count).to eql(231)
    end
  end

  context "#generate_mines" do
    it "creates a board with the given number of rows" do
      result = Minebumbler::Board.new.generate_mines(2,3,4)
      expect(result.length).to eql(2)
    end

    it "creates a board with the given number of columns" do
      result = Minebumbler::Board.new.generate_mines(2,3,4)
      expect(result.first.length).to eql(3)
    end

    it "creates a board with the given number of mines" do
      result = Minebumbler::Board.new.generate_mines(2,3,4)
      expect(result.flatten.count("X")).to eql(4)
    end
  end

  context "#add_number_cells" do
    it "includes at least 5 ones for a single mine" do
      cells_with_mines = Minebumbler::Board.new.generate_mines(5,5,1)
      result = Minebumbler::Board.new.add_number_cells(cells_with_mines)

      expect(result.flatten.count(1)).to be >= 5
    end
  end
end
