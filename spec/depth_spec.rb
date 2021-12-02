require 'rspec'
require '../solutions/d1_1'

RSpec.describe Depth do
  context 'setup' do
    subject { described_class.new }

    it 'reads the input file' do
      expect(subject.clean.count).to be > 1
    end
  end
end