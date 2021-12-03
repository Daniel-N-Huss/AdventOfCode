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
  end

end