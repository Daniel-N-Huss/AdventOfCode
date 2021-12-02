require 'rspec'
require_relative '../solutions/d2'

RSpec.describe Dive do
  describe 'initialize' do
    subject { described_class.new }

    it 'reads the input file' do
      puts subject.clean.inspect
      expect(subject.clean.count).to be > 1
    end
  end

  describe '' do
  end
end