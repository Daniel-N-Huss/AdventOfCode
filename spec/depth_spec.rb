require 'rspec'
require_relative '../solutions/d1_1'

RSpec.describe Depth do
  describe 'initialize' do
    subject { described_class.new }

    it 'reads the input file' do
      expect(subject.clean.count).to be > 1
    end
  end

  describe '.relative_increase' do
    subject { described_class.new.relative_increase(depths) }

    context 'with [1, 2, 3]' do
      let(:depths) { [1, 2, 3] }
      it { is_expected.to eq [true, true] }
    end

    context 'with [1, 0, 3]' do
      let(:depths) { [1, 0, 3] }
      it { is_expected.to eq [false, true] }
    end

    context 'with [190, 168, 166, 163, 170, 160, 171, 166, 161, 167, 175]' do
      let(:depths) { [190, 168, 166, 163, 170, 160, 171, 166, 161, 167, 175] }
      it { is_expected.to eq [false, false, false, true, false, true, false, false, true, true] }
    end
  end

  describe '.count_increases' do
    subject { described_class.new.count_increases(relative_depths) }

    context 'with [false, true, true, false, true]' do
      let(:relative_depths) { [false, true, true, false, true] }
      it { is_expected.to eq 3 }
    end

    context 'with [false, true, true, true, true]' do
      let(:relative_depths) { [false, true, true, true, true] }
      it { is_expected.to eq 4 }
    end

    context 'with [false, true, true, true, false]' do
      let(:relative_depths) { [false, true, true, true, false] }
      it { is_expected.to eq 3 }
    end

    context 'with [true, false, false, false, true, false, true, false, false, true, true]' do
      let(:relative_depths) { [true, false, false, false, true, false, true, false, false, true, true] }
      it { is_expected.to eq 5 }
    end

    context 'with [true, true, true, true, false, true, true]' do
      let(:relative_depths) { [true, true, true, true, false, true, true] }
      it { is_expected.to eq 6 }
    end
  end

  describe '.generate_measurement_windows' do
    subject { described_class.new.generate_measurement_windows(depths) }

    context 'array lengths' do
      context 'when array has 3 elements' do
        let(:depths) { [1, 2, 3] }

        it 'returns one measurement' do
          expect(subject.count).to eq 1
        end

        it { is_expected.to eq [6] }
      end

      context 'when array has 4 elements' do
        let(:depths) { [1, 2, 3, 4] }

        it 'returns 2 measurement' do
          expect(subject.count).to eq 2
        end

        it { is_expected.to eq [6, 9] }
      end

      context 'when array has 7 elements' do
        let(:depths) { [1, 2, 3, 4, 5, 6, 7] }

        it 'returns 5 measurements' do
          expect(subject.count).to eq 5
        end

        it { is_expected.to eq [6, 9, 12, 15, 18] }
      end
    end
  end
end