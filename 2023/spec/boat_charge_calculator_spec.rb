require_relative '../solutions/d6'

describe BoatChargeCalculator do
  let(:test_data) do
    <<~DATA
      Time:      7  15   30
      Distance:  9  40  200
    DATA
  end

  let(:calculator) { BoatChargeCalculator.new(test_data) }

  describe '#parse_input' do
    subject { calculator.parse_input }

    it 'sets up the time and distance arrays' do
      subject

      expect(calculator.times).to eq([7, 15, 30])
      expect(calculator.distances).to eq([9, 40, 200])
    end

    context 'with single race data' do
      let(:calculator) { BoatChargeCalculator.new(test_data, single_race: true) }

      it 'sets up the time and distance arrays' do
        subject

        expect(calculator.times).to eq([71530])
        expect(calculator.distances).to eq([940200])
      end
    end
  end

  describe '#multiply_winning_charge_times' do
    subject { calculator.multiply_winning_charge_times }

    it 'returns the product of the number of ways to win races' do
      calculator.parse_input
      expect(subject).to eq(288)
    end

    context 'with input data' do
      let(:test_data) { File.read('./inputs/d6.txt') }

      it 'returns the product of the number of ways to win races' do
        calculator.parse_input
        expect(subject).to eq(138915)
      end

      context 'with single race data' do
        let(:calculator) { BoatChargeCalculator.new(test_data, single_race: true) }

        it 'returns the product of the number of ways to win races' do
          calculator.parse_input
          expect(subject).to eq(27340847)
        end
      end
    end
  end

  describe '#find_min_winning_charge' do
    subject { calculator.find_min_winning_charge(time, distance) }
    let(:time) { 7 }
    let(:distance) { 9 }

    it 'returns the minimum charge time' do
      expect(subject).to eq(2)
    end
  end

  describe '#find_max_winning_charge' do
    subject { calculator.find_max_winning_charge(time, distance) }
    let(:time) { 7 }
    let(:distance) { 9 }

    it 'returns the minimum charge time' do
      expect(subject).to eq(5)
    end
  end
end
