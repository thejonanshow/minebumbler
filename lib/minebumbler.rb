require "minebumbler/version"
require "minebumbler/board"

module Minebumbler
  def start
    board = Minebumbler::Board.new(difficulty)
  end
end
