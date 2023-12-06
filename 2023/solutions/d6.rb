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

    if @single_race
      @times << sectioned_data[0].sub("Time: ", "").gsub(" ", "").to_i
      @distances << sectioned_data[1].sub("Distance: ", "").gsub(" ", "").to_i
    else
      sectioned_data.each do |line|
        if line.include?("Time:")
          @times = line.split(" ")[1..-1].map(&:to_i)
        elsif line.include?("Distance:")
          @distances = line.split(" ")[1..-1].map(&:to_i)
        end
      end
    end
  end

  def find_min_winning_charge(time, distance)
    charge_for_time = 1

    loop do
      remaining_race_time = time - charge_for_time
      velocity = charge_for_time * 1

      if (remaining_race_time * velocity) > distance
        return charge_for_time
      else
        charge_for_time += 1
      end
    end
  end

  def find_max_winning_charge(time, distance)
    charge_for_time = time

    loop do
      remaining_race_time = time - charge_for_time
      velocity = charge_for_time * 1

      if (remaining_race_time * velocity) > distance
        return charge_for_time
      else
        charge_for_time -= 1
      end
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
