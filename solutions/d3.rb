class PowerCalculator
  attr_reader :clean, :gamma, :epsilon, :oxygen, :co2_scrubber
  attr_accessor :rate_collection

  def initialize(test_data = nil)
    @input = test_data || File.open("./inputs/d3.txt").read
    @clean = @input.split("\n")
    @rate_collection = { '0': [], "1": [], "2": [], '3': [], '4': [], '5': [], '6': [], '7': [], '8': [], '9': [], '10': [], '11': [] }
    @gamma = ""
    @epsilon = ""

    @oxygen = ""
    @co2_scrubber = ""
  end

  def calculate_power
    input_into_rate_collection(clean)
    reduce_rate_collection

    gamma.to_i(2) * epsilon.to_i(2)
  end

  def input_into_rate_collection(input = nil)
    input.each do |measurement|
      measurement.split('').each_with_index { |bit, index| rate_collection[index.to_s.to_sym] << bit.to_i }
    end
  end

  def most_common_bit(bits)
    bits.max_by{ |bit| bits.count(bit) }
  end

  def reduce_rate_collection
    rate_collection.each do |key, rates|
      gamma_bit = most_common_bit(rates).to_s
      epsilon_bit = gamma_bit == "1" ? "0" : "1" #give inverted value for epsion

      gamma << gamma_bit
      epsilon << epsilon_bit
    end
  end

  def detect_oxygen

  end
end

# puts PowerCalculator.new.calculate_power