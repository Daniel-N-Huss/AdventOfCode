class ScratchCardPointCounter
  def initialize(ticket_pile)
    @ticket_pile = ticket_pile
  end

  def find_winning_numbers
    scratch_games = @ticket_pile.split("\n").map {|game| game.split(": ").last }

    ticket_numbers = scratch_games.map { |nums| nums.split("|").map { |numbers| numbers.split(" ").map(&:to_i) }}

    winning_numbers = ticket_numbers.map { |game| game.first & game.last }

    winning_numbers
  end

  def score_winning_numbers
    winning_numbers = find_winning_numbers

    winning_numbers.map do |ticket|
      case
      when ticket.length < 2
        ticket.length
      when ticket.length == 2
        2
      else
        ticket.pop
        ticket.reduce(1) { |memo, _num| memo * 2 }
      end
    end.sum
  end

  def setup_ticket_library
    winning_numbers = find_winning_numbers

    @ticket_library ||= {}

    winning_numbers.each_with_index do |ticket, index|
      @ticket_library[(index + 1)] = { winning_numbers: ticket.length, play_count: 1 }
    end if @ticket_library.empty?

    @ticket_library
  end

  def play
    setup_ticket_library

    @ticket_library.each do |game_number, data|
      case
      when data[:winning_numbers] <= 0
        next
      when data[:winning_numbers] == 1
        @ticket_library[(game_number + 1)][:play_count] += data[:play_count] if @ticket_library[(game_number + 1)]
      else
        ((game_number + 1)..(game_number + data[:winning_numbers])).each do |ticket_number|
          @ticket_library[ticket_number][:play_count] += data[:play_count] if @ticket_library[ticket_number]
        end
      end
    end

    @ticket_library
  end

  def count_played_tickets
    play
    @ticket_library.values.map { |data| data[:play_count] }.sum
  end
end
