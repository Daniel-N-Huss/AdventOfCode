class CubeBag
  attr_reader :played_games

  def initialize(raw_game_data)
    @raw_game_data = raw_game_data
    @played_games = []
  end

  def parse_played_games
    @raw_game_data.split("\n").each do |game|
      _, pull = game.split(': ')
      @played_games << { pulls: pull.split('; ').map { |color_die| color_die.split(', ') } }
    end
  end

  def max_pulled_cubes
    @played_games.map do |game|
      pulls = { red: [], blue: [], green: [] }
      game[:pulls].map do |pull|
        pull.map do |cube|
          number, color = cube.split(' ')
          pulls[color.to_sym] << number.to_i
        end
      end
      pulls.each { |color, numbers| pulls[color] = numbers.max }
    end
  end

  def valid_games
    included_cubes = { red: 12, green: 13, blue: 14 }

    valid_game_ids = []
    max_pulled_cubes.each_with_index do |cubes, game_number|
      valid = true
      cubes.each do |color, number|
        valid = false if number > included_cubes[color]
      end
      valid_game_ids << game_number + 1 if valid
    end
    valid_game_ids.sum
  end

  def power_of_minimum_dice
    max_pulled_cubes.map do |games|
      games.values.reduce(:*)
    end.sum
  end
end
