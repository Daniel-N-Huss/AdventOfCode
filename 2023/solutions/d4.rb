class ScratchCardPointCounter
  def initialize(ticket_pile)
    @ticket_pile = ticket_pile
  end

  def find_winning_numbers
    scratch_games = @ticket_pile.split("\n").map { |game| game.split(": ").last }

    ticket_numbers = scratch_games.map { |nums| nums.split("|").map { |numbers| numbers.split(" ").map(&:to_i) } }

    ticket_numbers.map { |game| game.first & game.last }
  end

  def score_winning_numbers
    find_winning_numbers.map do |ticket|
      if ticket.length <= 2
        ticket.length
      else
        ticket.pop
        ticket.reduce(1) { |memo, _num| memo * 2 }
      end
    end.sum
  end

  def setup_ticket_library
    @ticket_library ||= {}

    find_winning_numbers.each_with_index do |ticket, index|
      @ticket_library[index + 1] = { winning_numbers: ticket.length, play_count: 1 }
    end

    @ticket_library
  end

  def play
    setup_ticket_library

    @ticket_library.each do |game_number, data|
      next if data[:winning_numbers] <= 0

      games_to_add_plays = ((game_number + 1)..(game_number + data[:winning_numbers]))
      games_to_add_plays.each do |game|
        add_plays_to_next_game(data, game)
      end
    end

    @ticket_library
  end

  def count_played_tickets
    play
    @ticket_library.values.map { |data| data[:play_count] }.sum
  end

  private

  def add_plays_to_next_game(data, game_number)
    @ticket_library[(game_number)][:play_count] += data[:play_count] if @ticket_library[(game_number)]
  end
end
