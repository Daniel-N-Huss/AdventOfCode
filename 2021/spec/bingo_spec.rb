require 'rspec'
require_relative '../solutions/d4'

RSpec.describe Bingo do
  describe 'initialize' do
    subject { described_class.new(bingo_games) }

    context 'when no bingo games are provided' do
      let(:bingo_games) { nil }
      it 'reads the input file, when no test data is attached' do
        subject.input.inspect
        expect(subject.input.length).to be > 500
      end
    end

    context 'when test data is provided' do
      let(:bingo_games) do
        "10,80,6,69,22,99

      3 82 18 50 90
      16 37 52 67 28
      30 54 80 11 10
      60 79  7 65 58
      76 83 38 51  1

      10 80 6 69 99
      70 87  5 22 14
      85  3 11 16 33
      72 69 97 36 49
      26 17 58 13  2"
      end

      let(:raw_boards) do
        "3 82 18 50 90 16 37 52 67 28 30 54 80 11 10 60 79  7 65 58 76 83 38 51  1 10 80 6 69 99 70 87  5 22 14 85  3 11 16 33 72 69 97 36 49 26 17 58 13  2"
      end

      it 'reads the bingo_games' do
        expect(subject.input).to eq bingo_games
      end

      it 'has a list of call_numbers' do
        expect(subject.call_numbers).to eq(['10', '80', '6', '69', '22', '99'])
      end

      it 'has a collection of game boards' do
        expect(subject.game_boards.count).to eq 2
      end

      it 'holds the raw board data' do
        expect(subject.raw_board_data).to eq raw_boards
      end
    end
  end

end

RSpec.describe Board do
  describe 'initialize' do
    subject { described_class.new(test_data) }

    let(:test_data) { ["3 82 18 50 90", "16 37 52 67 28", "30 54 80 11 10", "60 79  7 65 58", "76 83 38 51  1"] }
    it 'has rows' do
      expect(subject.rows).to eq test_data
    end
  end
end