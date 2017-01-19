require "minebumbler/version"
require "minebumbler/board"

module Minebumbler
  def self.start(difficulty)
    board = Minebumbler::Board.new(difficulty)
    puts board.filtered
  end
end
