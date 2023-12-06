class BoatChargeCalculator
  attr_reader :times, :distances

  def initialize(race_data, single_race: false)
    @race_data = race_data
    @times = []
    @distances = []
    @single_race = single_race
  end

  def parse_input
    sectioned_data = @race_data.split("\n")

    times = sectioned_data[0].sub('Time: ', '').split(' ').map(&:to_i)
    distances = sectioned_data[1].sub('Distance: ', '').split(' ').map(&:to_i)

    if @single_race
      times = [times.join.to_i]
      distances = [distances.join.to_i]
    end

    @times = times
    @distances = distances
  end

  def find_min_winning_charge(time, distance)
    charge_for_time = 1

    loop do
      remaining_race_time = time - charge_for_time
      velocity = charge_for_time * 1

      return charge_for_time if (remaining_race_time * velocity) > distance

      charge_for_time += 1
    end
  end

  def find_max_winning_charge(time, distance)
    charge_for_time = time

    loop do
      remaining_race_time = time - charge_for_time
      velocity = charge_for_time * 1

      return charge_for_time if (remaining_race_time * velocity) > distance

      charge_for_time -= 1
    end
  end

  def multiply_winning_charge_times
    winning_charge_times = @times.map.with_index do |time, index|
      distance = @distances[index]
      min_charge = find_min_winning_charge(time, distance)
      max_charge = find_max_winning_charge(time, distance)

      max_charge - min_charge + 1
    end

    winning_charge_times.reduce(:*).to_i
  end
end
