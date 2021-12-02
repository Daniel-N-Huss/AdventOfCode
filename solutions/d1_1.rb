class Depth
  attr_accessor :clean
  def initialize
    @input = File.open("./inputs/d1_1").read
    @clean = @input.split.map(&:to_i)
  end

  def relative_increase(depths)
    depths.map.with_index { |depth, index| depth > depths[index - 1] }.drop(1)
  end

  def count_increases(relative_depths)
    relative_depths.select { |depth| depth }.count
  end

  def relative_result
    puts count_increases(relative_increase(clean))
  end

  def generate_measurement_windows(depths)
    result = depths.map.with_index { |depth, index| [depth, depths[index + 1], depths[index + 2]] }
    result[0...-2].map(&:sum)
  end

  def window_results
    puts count_increases(relative_increase(generate_measurement_windows(clean)))
  end

end

Depth.new.window_results