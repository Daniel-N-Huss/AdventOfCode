class Depth
  def initialize
    @input = File.open("../inputs/d1_1").read
    @clean = @input.split.map(&:to_i)
  end

  def print
    puts @clean.inspect
  end

end