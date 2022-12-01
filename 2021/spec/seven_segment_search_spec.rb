require_relative '../solutions/d8'
require 'rspec'

RSpec.describe SevenSegmentSearcher do
  let(:test_input) do
    "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
  end

  describe "sum_all_outputs" do
    subject { searcher.sum_all_outputs }
    let(:searcher) { SevenSegmentSearcher.new(test_input) }

    it { is_expected.to eq 61229 }
  end
end

RSpec.describe Readout do
  let(:input_readings) { 'edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec' }
  let(:output_readings) { 'fcgedb cgb dgebacf gc' }

  describe 'decode_from_input' do
    subject { readout.decode_from_input }
    let(:readout) { Readout.new(input_readings, output_readings) }

    it 'maps input representation to number' do
      subject

      expect(readout.number_dictionary[0]).to include('a', 'c', 'b', 'g', 'f', 'd')
      expect(readout.number_dictionary[1]).to include('g', 'c')
      expect(readout.number_dictionary[2]).to include('a', 'b', 'c', 'd', 'e')
      expect(readout.number_dictionary[3]).to include('b', 'e', 'g', 'c', 'd')
      expect(readout.number_dictionary[4]).to include('g', 'f', 'e', 'c')
      expect(readout.number_dictionary[5]).to include('f', 'b', 'g', 'd', 'e')
      expect(readout.number_dictionary[6]).to include('e', 'd', 'b', 'f', 'g', 'a')
      expect(readout.number_dictionary[7]).to include('c', 'b', 'g')
      expect(readout.number_dictionary[8]).to include('g', 'c', 'a', 'd', 'e', 'b', 'f')
      expect(readout.number_dictionary[9]).to include('g', 'f', 'c', 'b', 'e', 'd')

    end

    it 'maps which segment a letter represents' do
      subject
      expect(readout.segment_readings).to eq(
        { top_left_col: 'f',
          top_row: 'b',
          top_right_col: 'c',
          middle_row: 'e',
          bottom_left_col: 'a',
          bottom_row: 'd',
          bottom_right_col: 'g' }
      )
    end
  end

  describe "decode_output" do
    subject { readout.decode_output }
    let(:readout) { Readout.new(input_readings, output_readings) }

    it { is_expected.to eq 9781 }
  end
end
