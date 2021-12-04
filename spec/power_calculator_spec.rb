require 'rspec'
require_relative '../solutions/d3'

RSpec.describe PowerCalculator do
  subject { described_class.new(test_data) }
  let(:test_data) { nil }

  describe 'initialize' do
    context 'when no test data is provided' do
      it 'reads the input file, when no test data is attached' do
        expect(subject.clean.count).to be > 100
      end
    end
    context 'when test data is provided' do
      let(:test_data) { "110000000001\n010011111011" }

      it 'reads the test data' do
        expect(subject.clean.count).to be 2
        expect(subject.clean).to eq ['110000000001', '010011111011']
      end
    end

    it 'has a rate_collection measurement' do
      expect(subject.rate_collection).to eq({ '0': [], "1": [], "2": [], '3': [], '4': [], '5': [], '6': [], '7': [], '8': [], '9': [], '10': [], '11': [] })
    end

    it 'has a placeholder gamma rate' do
      expect(subject.gamma).to eq ""
    end

    it 'has a placeholder epsilon rate' do
      expect(subject.epsilon).to eq ""
    end

    it 'has a placeholder oxygen rate' do
      expect(subject.oxygen).to eq ""
    end

    it 'has a placeholder co2_scrubber rate' do
      expect(subject.co2_scrubber).to eq ""
    end
  end

  describe ".input_into_rate_collection" do
    let(:power_calculator) { described_class.new("placeholder") }
    let(:test_data) { ["110000000001", "010011111011"] }

    subject { power_calculator.input_into_rate_collection(test_data) }

    it 'splits the input into the indexed rate_collection' do
      subject
      expect(power_calculator.rate_collection).to eq({ '0': [1, 0], "1": [1, 1], "2": [0, 0], '3': [0, 0], '4': [0, 1], '5': [0, 1], '6': [0, 1], '7': [0, 1], '8': [0, 1], '9': [0, 0], '10': [0, 1], '11': [1, 1] })
    end
  end

  describe 'most_common_bit' do
    subject { described_class.new.most_common_bit(rate_count) }

    context 'with majority 0 bits' do
      let(:rate_count) { [1, 0, 0] }

      it { is_expected.to eq 0 }
    end

    context 'with majority 1 bits' do
      let(:rate_count) { [1, 1, 0] }

      it { is_expected.to eq 1 }
    end

    context 'when bits are even' do
      let(:rate_count) { [1, 1, 0, 0] }

      it { is_expected.to eq nil }
    end

  end

  describe 'least_common_bit' do
    subject { described_class.new.least_common_bit(rate_count) }

    context 'with majority 0 bits' do
      let(:rate_count) { [1, 0, 0] }

      it { is_expected.to eq 1 }
    end

    context 'with majority 1 bits' do
      let(:rate_count) { [1, 1, 0] }

      it { is_expected.to eq 0 }
    end

    context 'when bits are even' do
      let(:rate_count) { [1, 1, 0, 0] }

      it { is_expected.to eq nil }
    end
  end

  describe 'reduce_rate_collection' do
    let(:power_calculator) { described_class.new("placeholder") }

    subject { power_calculator.reduce_rate_collection }

    before do
      power_calculator.rate_collection = { '0': [1, 0, 0], "1": [1, 1, 1], "2": [0, 0, 1], '3': [0, 0, 0], '4': [0, 1, 1], '5': [0, 1, 0], '6': [0, 1, 1], '7': [0, 1, 0], '8': [0, 1, 1], '9': [0, 0, 0], '10': [0, 1, 1], '11': [1, 1, 1] }
    end

    it 'sets the gamma rate' do
      subject
      expect(power_calculator.gamma).to eq("010010101011")
    end
    it 'sets the epsilon rate' do
      subject
      expect(power_calculator.epsilon).to eq("101101010100")
    end
  end

  describe 'calculate_power' do
    let(:power_calculator) { described_class.new(test_data) }
    let(:test_data) { "110000000001\n010011111011\n111000011110" }

    # expected gamma from test input = 110000011011
    # expected epsilon from test input = 001111100100

    subject { power_calculator.calculate_power }

    it 'processes input data, and returns the product of the gamma and epsilon measurements' do
      expect(subject).to eq 3086604
      #gamma to decimal value = 3099
      # epsilon to decimal value = 996
      # 3099 * 996 = 3086604
    end
  end

  describe 'detect_oxygen' do
    let(:power_calculator) { described_class.new("placeholder") }
    let(:test_data) { ["10100", "00000", "11100", "11110"] }
    subject { power_calculator.detect_oxygen(test_data) }

    it { is_expected.to eq "11110" }

    context 'with a specific inputs' do
      let(:power_calculator) { described_class.new("placeholder") }
      subject { power_calculator.detect_oxygen(test_data) }

      context 'when test data is 010, 000, 100' do
        let(:test_data) { ["010", "000", "100"] }

        it { is_expected.to eq "010" }
      end

      context 'when test data is 0100, 0000, 0001, 1000' do
        let(:test_data) { ["0100", "0000", "0001", "1000"] }

        it { is_expected.to eq "0001" }
      end

      context 'when test data is 111000111010, 111000111000' do
        let(:test_data) { ['111000111010', '111000111000'] }

        it { is_expected.to eq '111000111010' }
      end
    end
  end

  describe 'detect_carbon_scrubbing' do
    let(:power_calculator) { described_class.new("placeholder") }
    let(:test_data) { ["10", "10", "10", "10", "010", "011"] }
    subject { power_calculator.detect_carbon_scrubbing(test_data) }

    it { is_expected.to eq "010" }

    describe 'with a specific input' do
      let(:power_calculator) { described_class.new("placeholder") }
      let(:test_data) { ["111000111010", "111000111000"] }
      subject { power_calculator.detect_carbon_scrubbing(test_data) }

      it { is_expected.to eq "111000111000" }
    end

  end

  describe 'calculate_life_support_rating' do
    let(:power_calculator) { described_class.new("110000000001\n010011111011\n111000011110") }
    #3073,1275, 3614
    subject { power_calculator.calculate_life_support_rating }

    it { is_expected.to eq 4607850 } #3614 * 1275
    #detect oxygen will select the third binary value, detect co2 scrubbing will select the second, multiply result
  end
end