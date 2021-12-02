class Dive
  attr_reader :clean
  def initialize(test_input = nil)
    @input = test_input || File.open("./inputs/d2.txt").read
    @clean = cleanup

  end

  def cleanup
    @input.split("\n").map(&:split)
  end

end
