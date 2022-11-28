require 'rspec'
require_relative '../solutions/d4'

RSpec.describe Bingo do
  let(:bingo_games) do
    "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"
  end

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
      it 'reads the bingo_games' do
        expect(subject.input).to eq bingo_games
      end

      it 'has a list of call_numbers' do
        expect(subject.call_numbers).to eq %w[7 4 9 5 11 17 23 2 0 14 21 24 10 16 13 6 15 25 12 22 18 20 8 19 3 26 1]
      end

      it 'has a collection of game boards' do
        expect(subject.game_boards.count).to eq 3
      end

      it 'holds the raw board data' do
        expect(subject.raw_board_data).to include('22 13 17 11  0')
        expect(subject.raw_board_data).to include('8  2 23  4 24')
        expect(subject.raw_board_data).to include('21  9 14 16  7')
        expect(subject.raw_board_data).to include('6 10  3 18  5')
        expect(subject.raw_board_data).to include('1 12 20 15 19')

        expect(subject.raw_board_data).not_to include('7 4 9 5 11 17 23 2 0 14 21 24 10 16 13 6 15 25 12 22 18 20 8 19 3 26 1')

      end
    end
  end

  # split out the list of call numbers, and game boards
  # draw one number from the list at a time
  # mark each number as drawn on all boards
  # check if the board has a completed row
  # score the board by
  #   sum all unmarked numbers
  #   multiply sum by the number that was called

  describe ".play" do
    subject { bingo.play }

    let(:bingo) { Bingo.new(bingo_games) }

    it { is_expected.to eq 1924 }
  end
end

RSpec.describe Board do
  let(:board_numbers) do
    ['22 13 17 11  0',
     '8  2 23  4 24',
     '21  9 14 16  7',
     '6 10  3 18  5',
     '1 12 20 15 19']
  end

  describe 'initialize' do
    subject { Board.new(board_numbers) }

    it "tracks numbers in each row" do
      expect(subject.top).to eq [22, 13, 17, 11, 0]
      expect(subject.upper).to eq [8, 2, 23, 4, 24]
      expect(subject.middle).to eq [21, 9, 14, 16, 7]
      expect(subject.lower).to eq [6, 10, 3, 18, 5]
      expect(subject.bottom).to eq [1, 12, 20, 15, 19]
    end

    it "tracks matched count" do
      expect(subject.matched_count).to eq 0
    end

    it "knows if it's won already" do
      expect(subject.won).to eq false
    end
  end

  describe ".call" do
    subject { board.call(number) }

    let(:board) { Board.new(board_numbers) }

    context "when called number does not exist on the board" do
      let(:number) { '99' }

      it "does nothing" do
        expect { subject }.not_to change { board.top }
        expect { subject }.not_to change { board.upper }
        expect { subject }.not_to change { board.middle }
        expect { subject }.not_to change { board.lower }
        expect { subject }.not_to change { board.bottom }

        expect(subject).to eq false
      end
    end

    context "when called number exists on the board" do
      let(:number) { '22' }

      it "changes the called number to a boolean" do
        expect(subject).to eq true
        expect(board.top.first).to eq true
      end

      it "increments the matched count" do
        expect { subject }.to change { board.matched_count }.by 1
      end
    end
  end

  describe ".wins?" do
    subject { board.wins? }
    context "when board does not have matched numbers" do
      let(:board) { Board.new(board_numbers) }

      it { is_expected.to be false }
    end

    context "when board has matched numbers" do
      let(:board) { Board.new(board_numbers, test_override) }

      context "when there are matches, but no full row or column" do
        let(:test_override) do
          { top: [true, 13, 17, 11, 0],
            upper: [8, 2, true, 4, 24],
            middle: [21, 9, 14, 16, 7],
            lower: [6, 10, 3, 18, true],
            bottom: [1, 12, 20, true, 19]
          }
        end

        it { is_expected.to be false }
      end

      context "when a full column matches" do
        let(:test_override) do
          { top: [true, 13, 17, 11, 0],
            upper: [true, 2, 11, 4, 24],
            middle: [true, 9, 14, 16, 7],
            lower: [true, 10, 3, 18, 44],
            bottom: [true, 12, 20, 13, 19]
          }
        end

        it { is_expected.to be true }

        it "updates the won tracking" do
          subject
          expect(board.won).to eq true
        end
      end

      context "when a full column matches, with extra true values" do
        let(:test_override) do
          { top: [true, 13, true, 11, true],
            upper: [true, 2, 11, true, 24],
            middle: [true, 9, 14, 16, 7],
            lower: [true, 10, 3, 18, 44],
            bottom: [true, 12, 20, 13, 19]
          }
        end

        it { is_expected.to be true }
      end

      context "when a full row matches" do
        let(:test_override) do
          { top: [8, 13, 17, 11, 0],
            upper: [21, 2, 11, 4, 24],
            middle: [6, 9, 14, 16, 7],
            lower: [1, 10, 3, 18, 44],
            bottom: [true, true, true, true, true]
          }
        end

        it { is_expected.to be true }
      end
    end
  end


  describe ".tally" do
    subject { board.tally }

    let(:board) { Board.new(board_numbers, test_override) }

    let(:test_override) do
      { top: [true, 13, true, 11, true],
        upper: [true, 2, 11, true, 24],
        middle: [true, 9, 14, 16, 7],
        lower: [true, 10, 3, 18, 44],
        bottom: [true, 12, 20, 13, 19]
      }
    end

    let(:non_marked_numbers) { [13, 11, 2, 11, 24, 9, 14, 16, 7, 10, 3, 18, 44, 12, 20, 13, 19] }

    it { is_expected.to eq non_marked_numbers.sum }
  end
end
