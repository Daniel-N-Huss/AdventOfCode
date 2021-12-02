require 'rspec'
require_relative '../solutions/d2'

RSpec.describe Dive do
  subject { described_class.new(test_data) }
  let(:test_data) { nil }

  describe 'initialize' do
    context 'when no test data is provided' do

      it 'reads the input file, when no test data is attached' do
        expect(subject.clean.count).to be > 100
      end
    end

    context 'when test data is provided' do
      let(:test_data) { "Blah 2\nFake 1" }

      it 'reads the test data' do
        expect(subject.clean.count).to be 2
        expect(subject.clean.first).to eq ["Blah", "2"]
      end
    end

    it 'has a position measurement' do
      expect(subject.position).to eq({ aim: 0, depth: 0, horizontal: 0 })
    end
  end

  describe '.evaluate_directions' do
    let(:dive) { Dive.new(test_data) }
    subject { dive.evaluate_directions }

    context 'when instructions include "forward"' do
      let(:test_data) { "forward 2" }

      it "increments the horizontal position" do
        subject
        expect(dive.position).to eq({ aim: 0, depth: 0, horizontal: 2 })
      end
    end

    context 'when instructions include "down"' do
      let(:test_data) { "down 2" }

      it "increments the depth position" do
        subject
        expect(dive.position).to eq({ aim: 0, depth: 2, horizontal: 0 })
      end
    end

    context 'when instructions include "up"' do
      let(:test_data) { "up 2" }

      it "decrements the depth position" do
        subject
        expect(dive.position).to eq({ aim: 0, depth: -2, horizontal: 0 })
      end
    end

    context 'when instructions include all directions' do
      let(:test_data) { "down 4\nup 2\nforward 3" }

      it "decrements the depth position" do
        subject
        expect(dive.position).to eq({ aim: 0, depth: 2, horizontal: 3 })
      end

    end
  end

  describe '.result' do
    let(:dive) { described_class.new(test_data) }
    subject { dive.result }
    let(:test_data) { "placeholder" }

    before do
      dive.position = { depth: 2, horizontal: 2 }
    end
    it 'returns the multiplication of both positional elements' do
      expect(subject).to eq 4
    end
  end
end