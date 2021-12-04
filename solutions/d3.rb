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
    @rate_collection = { '0': [], "1": [], "2": [], '3': [], '4': [], '5': [], '6': [], '7': [], '8': [], '9': [], '10': [], '11': [] } #reset rate collection for lifesupport checks
    input.each do |measurement|
      measurement.split('').each_with_index { |bit, index| rate_collection[index.to_s.to_sym] << bit.to_i }
    end
  end

  def most_common_bit(bits)
    max = bits.max_by { |bit| bits.count(bit) }
    return max if bits.count(max) > bits.length / 2 #handle ties by returning nil
  end

  def least_common_bit(bits)
    min = bits.min_by { |bit| bits.count(bit) }
    return min unless most_common_bit(bits) == nil
  end

  def reduce_rate_collection
    rate_collection.each do |key, rates|
      gamma_bit = most_common_bit(rates).to_s
      epsilon_bit = gamma_bit == "1" ? "0" : "1" #give inverted value for epsion

      gamma << gamma_bit
      epsilon << epsilon_bit
    end
  end

  def detect_oxygen(dataset, filter_at_index = 0)
    return dataset.first if dataset.count == 1
    if dataset.length == 2
      tiebreaker = dataset.select { |datum| datum[filter_at_index] == "1" }
      return tiebreaker.first if tiebreaker.count == 1
    end

    input_into_rate_collection(dataset)
    common_bit = most_common_bit(rate_collection[filter_at_index.to_s.to_sym])&.to_s || "1" #testing incomplete here, on the 'or 1 '

    filtered_dataset = dataset.select do |datum|
      datum[filter_at_index] == common_bit
    end
    return detect_oxygen(filtered_dataset, filter_at_index + 1)

  end

  def detect_carbon_scrubbing(dataset, filter_at_index = 0)
    return dataset.first if dataset.count == 1

    if dataset.length == 2
      tiebreaker = dataset.select { |datum| datum[filter_at_index + 1] == "0" }
      return tiebreaker.first if tiebreaker.count == 1
    end

    input_into_rate_collection(dataset)
    least_common_bit = least_common_bit(rate_collection[filter_at_index.to_s.to_sym])&.to_s || "0" #testing incomplete here, on the 'or 0 '

    if least_common_bit
      filtered_dataset = dataset.select do |datum|
        datum[filter_at_index] == least_common_bit
      end
    end

    return detect_carbon_scrubbing(filtered_dataset, filter_at_index + 1)
  end

  def calculate_life_support_rating
    oxygen = detect_oxygen(clean)
    co2 = detect_carbon_scrubbing(clean)

    oxygen.to_i(2) * co2.to_i(2)
  end

end

p = PowerCalculator.new
puts p.calculate_life_support_rating