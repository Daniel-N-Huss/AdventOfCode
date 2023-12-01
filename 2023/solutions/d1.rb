# frozen_string_literal: true

class Calibrator
  def initialize(input, parse_text_numbers: false)
    @input = input
    @parse_text_based_numbers = parse_text_numbers
  end

  def call
    @input.split("\n").map do |line|
      possible_calibrations = line.scan(matcher).flatten
      "#{NumberParser.fetch(possible_calibrations.first)}#{NumberParser.fetch(possible_calibrations.last)}".to_i
    end.sum
  end

  private

  def matcher
    if @parse_text_based_numbers
      /(?=(one|two|three|four|five|six|seven|eight|nine|\d))/
    else
      /(?=(\d))/
    end
  end
end

class NumberParser
  NUMBER_DICT = {
    'one' => '1',
    'two' => '2',
    'three' => '3',
    'four' => '4',
    'five' => '5',
    'six' => '6',
    'seven' => '7',
    'eight' => '8',
    'nine' => '9'
  }.freeze

  def self.fetch(unparsed_text)
    NUMBER_DICT.fetch(unparsed_text) { |key| key }
  end
end
