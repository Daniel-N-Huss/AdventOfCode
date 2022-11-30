class FuelSaver
  def initialize(initial_submarine_positions)
    @initial_submarine_positions = initial_submarine_positions.split(",").collect(&:to_i)
    @min_position = @initial_submarine_positions.min
    @max_position = @initial_submarine_positions.max
    @distance_costs = scaling_distance_costs
  end

  def minimum_fuel_cost
    result = {}

    (@min_position..@max_position).each do |possible_end_position|
      distances_to_possble_position = @initial_submarine_positions.collect do |initial_sub_position|
        number_of_steps = (initial_sub_position - possible_end_position).abs

        @distance_costs[number_of_steps]
      end

      result[possible_end_position] = distances_to_possble_position.sum
    end

    result.values.min
  end

  def scaling_distance_costs
    max_possible_steps = @max_position - @min_position

    steps = (0..max_possible_steps).to_a
    distance_calcs = steps.map do |step|
      if step == 0
        [step, 0]
      else
        [step, step + steps.slice(0, step).sum]
      end
    end

    distance_calcs.to_h
  end
end

input = File.open(File.absolute_path("./2021/inputs/d7.txt")).read

puts FuelSaver.new(input).minimum_fuel_cost