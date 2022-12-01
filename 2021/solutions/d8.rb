class SevenSegmentSearcher
  def initialize(segment_readings)
    @segment_readings = segment_readings.split("\n").collect do |segment|
      signal_pattern, output = segment.split(' | ')
      Readout.new(signal_pattern, output)
    end
  end

  def sum_all_outputs
    @segment_readings.collect(&:decode_output).sum
  end
end

class Readout
  attr_reader :number_dictionary, :segment_readings

  SEGMENT_MAPPING = { 0 => %i[top_left_col top_row top_right_col bottom_left_col bottom_row bottom_right_col],
                      1 => %i[top_right_col top_left_col],
                      2 => %i[top_row top_right_col middle_row bottom_left_col bottom_row],
                      3 => %i[top_row top_right_col middle_row bottom_right_col bottom_row],
                      4 => %i[top_left_col middle_row top_right_col bottom_right_col],
                      5 => %i[top_row top_left_col middle_row bottom_right_col bottom_row],
                      6 => %i[top_row top_left_col bottom_left_col bottom_row bottom_right_col middle_row],
                      7 => %i[top_row top_right_col bottom_right_col],
                      8 => %i[top_left_col top_row top_right_col middle_row bottom_left_col bottom_row
                              bottom_right_col],
                      9 => %i[top_row top_left_col middle_row top_right_col bottom_right_col bottom_row] }.freeze

  def initialize(input_readings, output_readings)
    @number_dictionary = { 0 => nil, 1 => nil, 2 => nil, 3 => nil, 4 => nil, 5 => nil, 6 => nil, 7 => nil, 8 => nil,
                           9 => nil }

    @segment_readings = { top_left_col: [], top_row: [], top_right_col: [], middle_row: [], bottom_left_col: [],
                          bottom_row: [], bottom_right_col: [] }

    @input_readings = input_readings.split(' ').collect { |input_string| input_string.chars.sort.join }.sort_by(&:length)
    @output_readings = output_readings.split(' ').collect { |input_string| input_string.chars.sort.join }
  end

  def decode_output
    decode_from_input

    decoder_ring = @number_dictionary.invert

    @output_readings.collect { |reading| decoder_ring[reading] }.join.to_i
  end

  def decode_from_input
    one, seven, four = @input_readings.shift(3)
    eight = @input_readings.pop


    number_dictionary[1] = one
    number_dictionary[4] = four
    number_dictionary[7] = seven
    number_dictionary[8] = eight

    segment_readings[:top_row] = (seven.chars - one.chars).first

    x = (four.chars - seven.chars)

    segment_readings[:top_left_col] = x

    zero_six_nine_x, zero_six_nine_y, zero_six_nine_z = @input_readings.select { |input| input.length == 6 }

    grouping = []

    grouping << (eight.chars - zero_six_nine_x.chars).first
    grouping << (eight.chars - zero_six_nine_y.chars).first
    grouping << (eight.chars - zero_six_nine_z.chars).first


    segment_readings[:middle_row] = x.intersection(grouping).first

    segment_readings[:top_left_col] = (x - [segment_readings[:middle_row]]).first

    grouping.reject! { |elem| elem == segment_readings[:middle_row] }

    segment_readings[:bottom_left_col] = grouping
    segment_readings[:top_right_col] = grouping


    bottom_left_and_row_group = (eight.chars - four.chars) - seven.chars

    segment_readings[:bottom_left_col] = bottom_left_and_row_group.intersection(grouping).first

    segment_readings[:bottom_row] = bottom_left_and_row_group.reject { |elem| elem == segment_readings[:bottom_left_col] }.first

    segment_readings[:top_right_col] = grouping.reject { |elem| elem == segment_readings[:bottom_left_col] }.first

    claimed_letters = segment_readings.values.reject(&:empty?)

    segment_readings[:bottom_right_col] = ['a', 'b', 'c', 'd', 'e', 'f', 'g'].reject do |letter|
      claimed_letters.include?(letter)
    end.first

    unknown_nums = [0, 2, 3, 5, 6, 9]

    unknown_nums.each do |num|
      number_dictionary[num] = SEGMENT_MAPPING[num].collect { |segment| segment_readings[segment] }.sort.join
    end
  end
end

# input = File.open(File.absolute_path("./2021/inputs/d8.txt")).read

# puts SevenSegmentSearcher.new(input).sum_all_outputs
