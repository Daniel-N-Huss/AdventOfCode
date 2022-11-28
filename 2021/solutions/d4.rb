class Bingo
  attr_reader :input
  attr_accessor :call_numbers, :game_boards, :raw_board_data

  def initialize(bingo_games = nil)
    @input = bingo_games || File.open(File.absolute_path("../inputs/d4.txt")).read
    @parsed_games = parse_games
    @call_numbers = @parsed_games[:call_numbers]
    @raw_board_data = @parsed_games[:raw_boards]
    @game_boards = @parsed_games[:boards]
  end

  def parse_games
    result = {}

    split_call_from_boards = input.split("\n")

    result[:call_numbers] = split_call_from_boards.shift.split(',')

    board_rows = split_call_from_boards.reject(&:empty?)
    clean_board_rows = board_rows.collect(&:strip)
    result[:raw_boards] = clean_board_rows.join(' ')

    result[:boards] = []
    (clean_board_rows.count / 5).times do
      result[:boards] << Board.new(clean_board_rows.shift(5))
    end

    result
  end

  def play
    call_numbers.each do |calling|

      if @game_boards.count == 1
        last_board = @game_boards.first
        last_board.call(calling)
        result = last_board.tally * calling.to_i
        puts result
        return result
      end

      @game_boards.each do |board|
        board.call(calling)

        if board.matched_count >= 5
          if board.wins?
            @game_boards = @game_boards.reject { |board| board.won == true }
          end
        end
      end
    end
  end
end

class Board
  attr_reader :rows, :top, :upper, :middle, :lower, :bottom, :row_list, :matched_count, :won

  def initialize(rows, overrides = {})
    @rows = rows
    @top = overrides[:top] || parse_row(rows.first)
    @upper = overrides[:upper] || parse_row(rows[1])
    @middle = overrides[:middle] || parse_row(rows[2])
    @lower = overrides[:lower] || parse_row(rows[3])
    @bottom = overrides[:bottom] || parse_row(rows[4])
    @row_list = [@top, @upper, @middle, @lower, @bottom]
    @matched_count = 0
    @won = false
  end

  def parse_row(row)
    row.split(' ').collect(&:to_i)
  end

  def call(number)
    match_found = false

    row_list.each do |row|
      if replace_matched_number(number, row)
        match_found = true
        @matched_count += 1
        break
      end
    end

    match_found
  end

  def wins?
    row_list.each do |row|
      if row == [true, true, true, true, true]
        @won = true
        return true
      end
    end

    possible_column_wins = []

    @top.each_with_index { |value, index| possible_column_wins << index if value == true }

    possible_column_wins.each do |column_index|
      if (@upper[column_index] == true && @middle[column_index] == true && @lower[column_index] == true && @bottom[column_index] == true)
        @won = true
        return true
      end
    end

    false
  end

  def tally
    @row_list.collect do |row|
      row.reject { |number| number == true }.sum
    end.sum
  end

  def replace_matched_number(number, row)
    number_location = row.index(number.to_i)
    row[number_location] = true if number_location
  end
end

Bingo.new.play
