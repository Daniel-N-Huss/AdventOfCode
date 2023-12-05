require_relative '../solutions/d4'

RSpec.describe ScratchCardPointCounter do

  let(:test_data) do
    <<~TEST_DATA
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    TEST_DATA
  end

  describe '#initialize' do
    subject { ScratchCardPointCounter.new(test_data) }
    it { is_expected.to be_a ScratchCardPointCounter }
  end

  describe '#find_winning_numbers' do
    subject { ScratchCardPointCounter.new(test_data).find_winning_numbers }

    it 'returns an array of cards and the valid numbers' do
      expect(subject).to eq [[48, 83, 86, 17], [32, 61], [1, 21], [84], [], []]
    end
  end

  describe '#score_winning_numbers' do
    subject { ScratchCardPointCounter.new(test_data).score_winning_numbers }

    it 'totals up points, doubling per winning number per ticket' do
      expect(subject).to eq [8, 2, 2, 1, 0, 0].sum
    end

    context 'with input data' do
      let(:test_data) { File.read('./inputs/d4.txt') }

      it { is_expected.to eq 26346 }
    end
  end

  describe '#setup_ticket_library' do
    subject { ScratchCardPointCounter.new(test_data).setup_ticket_library }

    it 'should return a lookup hash, with the number of winning tickets' do
      expect(subject).to eq({ 1 => { winning_numbers: 4, play_count: 1 }, 2 => { winning_numbers: 2, play_count: 1 },
                              3 => { winning_numbers: 2, play_count: 1 }, 4 => { winning_numbers: 1, play_count: 1 },
                              5 => { winning_numbers: 0, play_count: 1 }, 6 => { winning_numbers: 0, play_count: 1 } })
    end
  end

  describe '#play' do
    subject { ScratchCardPointCounter.new(test_data).play }

    it 'should increment the play count for subsequent tickets' do
      expect(subject).to eq({ 1 => { winning_numbers: 4, play_count: 1 }, 2 => { winning_numbers: 2, play_count: 2 },
                              3 => { winning_numbers: 2, play_count: 4 }, 4 => { winning_numbers: 1, play_count: 8 },
                              5 => { winning_numbers: 0, play_count: 14 }, 6 => { winning_numbers: 0, play_count: 1 } })
    end
  end

  describe '#count_played_tickets' do
    subject { ScratchCardPointCounter.new(test_data).count_played_tickets }

    it 'should return the total number of tickets played' do
      expect(subject).to eq 30
    end

    context "with input data" do
      let(:test_data) { File.read('./inputs/d4.txt') }

      it { is_expected.to eq 8467762 }
    end
  end
end