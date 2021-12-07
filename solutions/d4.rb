class Bingo
  attr_reader :input
  attr_accessor :call_numbers, :game_boards, :raw_board_data
  def initialize(bingo_games = nil)
    @input = bingo_games || File.open("./inputs/d4.txt").read
    @parsed_games = parse_games
    @call_numbers = @parsed_games[:call_numbers]
    @raw_board_data = @parsed_games[:raw_boards]
    @game_boards = @parsed_games[:boards]
  end

  def parse_games
    result = {}

    split_call_from_boards = input.split("\n")

    result[:call_numbers] = split_call_from_boards.shift.split(",")

    board_rows = split_call_from_boards.select { |row| !row.empty? }
    clean_board_rows = board_rows.collect(&:strip)
    result[:raw_boards] = clean_board_rows.join(" ")

    result[:boards] = []
    (clean_board_rows.count / 5).times do
      result[:boards] << Board.new(clean_board_rows.shift(5))
    end

    result
  end
end

class Board
  attr_reader :rows
  def initialize(rows)
    @rows = rows
  end
end