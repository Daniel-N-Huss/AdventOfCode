class Dive
  attr_reader :clean
  attr_accessor :position
  def initialize(test_input = nil)
    @input = test_input || File.open("./inputs/d2.txt").read
    @clean = cleanup
    @position = { aim: 0, depth: 0, horizontal: 0 }
  end

  def cleanup
    @input.split("\n").map(&:split)
  end

  def evaluate_directions
    clean.each do |instruction|
      direction = instruction.first

      if direction == "forward"
        position[:horizontal] += instruction.last.to_i
      end

      if direction == "down"
        position[:aim] += instruction.last.to_i
      end

      if direction == "up"
        position[:aim] -= instruction.last.to_i
      end
    end
  end

  def result
    position[:depth] * position[:horizontal]
  end
end

d = Dive.new
d.evaluate_directions
puts d.result