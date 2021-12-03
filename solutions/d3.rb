class PowerCalculator
  attr_reader :clean
  attr_accessor :rate_collection

  def initialize(test_data = nil)
    @input = test_data || File.open("./inputs/d3.txt").read
    @clean = @input.split("\n")
    @rate_collection = { '0': [], "1": [], "2": [], '3': [], '4': [], '5': [], '6': [], '7': [], '8': [], '9': [], '10': [], '11': [] }
  end

  def input_into_rate_collection
    clean.each do |measurement|
      measurement.split('').each_with_index { |bit, index| rate_collection[index.to_s.to_sym] << bit.to_i }
    end
  end

  def most_common_bit(bits)
    bits.max_by{ |bit| bits.count(bit) }
  end
end
