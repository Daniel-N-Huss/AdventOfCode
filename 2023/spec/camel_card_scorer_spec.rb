require_relative '../solutions/d7'

RSpec.describe CamelCardScorer do
  let(:test_input) do
    <<~TEST_INPUT
      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483
    TEST_INPUT
  end

  let(:scorer) { CamelCardScorer.new(test_input, wild_j: wild_j) }
  let(:wild_j) { false }

  describe '#parse_input' do
    subject { scorer.parse_input }

    it 'returns an array of hands and bids' do
      expect(subject).to eq(
        [
          ['32T3K', 765,],
          ['T55J5', 684,],
          ['KK677', 28,],
          ['KTJJT', 220,],
          ['QQQJA', 483]
        ]
      )
    end
  end

  describe '#sort_hands_by_strength' do
    before do
      allow(scorer).to(receive(:parse_input)) { sorting_case }
    end

    subject { scorer.sort_hands_by_strength }

    context 'all basic hand strengths' do
      let(:sorting_case) do
        [
          ['KK677'], # two pair
          ['JJJKT'], # three of a kind
          ['AAAAA'], # five of a kind
          ['23456'], # high card
          ['T55J6'], # pair
          ['QQQQA'], # four of a kind
          ['KKKTT'] # full house
        ]
      end

      it 'returns by most matches' do
        expect(subject).to eq(
          [
            ['23456'], # high card
            ['T55J6'], # pair
            ['KK677'], # two pair
            ['JJJKT'], # three of a kind
            ['KKKTT'], # full house
            ['QQQQA'], # four of a kind
            ['AAAAA'] # five of a kind
          ]
        )
      end

      context "when J's are wild" do
        let(:wild_j) { true }

        let(:sorting_case) do
          [
            ['KK677'], # two pair
            ['JJJKT'], # four of a kind
            ['AAAAA'], # five of a kind
            ['JJJJJ'], # five of a kind
            ['23456'], # high card
            ['T55J6'], # three of a kind
            ['JKJJT'], # four of a kind
            ['QQQQA'], # four of a kind
            ["6KT3J"], # pair
            ['KKJTT'] # full house
          ]
        end

        it 'returns by most matches' do
          expect(subject).to eq(
            [
              ['23456'], # high card
              ["6KT3J"], # pair
              ['KK677'], # two pair
              ['T55J6'], # three of a kind
              ['KKJTT'], # full house
              ['JJJKT'], # four of a kind
              ['JKJJT'], # four of a kind
              ['QQQQA'], # four of a kind
              ['JJJJJ'], # five of a kind
              ['AAAAA'], # five of a kind
            ]
          )
        end
      end
    end

    context 'with the whole test input' do
      let(:sorting_case) do
        [
          ['32T3K', 765],
          ['T55J5', 684],
          ['KK677', 28],
          ['KTJJT', 220],
          ['QQQJA', 483]
        ]
      end

      it 'returns an array of hands and bids sorted by strength' do
        expect(subject).to eq(
          [
            ['32T3K', 765],
            ['KTJJT', 220],
            ['KK677', 28],
            ['T55J5', 684],
            ['QQQJA', 483]
          ]
        )
      end

      context 'when J cards are wild' do
        let(:wild_j) { true }

        it 'returns hands sorted by strength, with J cards improving the score of other sets' do
          expect(subject).to eq(
            [
              ['32T3K', 765],
              ['KK677', 28],
              ['T55J5', 684],
              ['QQQJA', 483],
              ['KTJJT', 220]
            ]
          )
        end

        context 'with tiebreaking hands' do
          let(:sorting_case) do
            [
              ['2JJJJ', 765],
              ['JJJJA', 483],
              ['JJJJ5', 765],
              ["A552T", 972],
              ["J6TA4", 351]
            ]
          end

          it "scores the J lowest" do
            expect(subject).to eq(
              [
                ["J6TA4", 351],
                ["A552T", 972],
                ['JJJJ5', 765],
                ['JJJJA', 483],
                ['2JJJJ', 765]
              ]
            )
          end
        end
      end
    end
  end

  describe "#evaluate_hand" do
    subject { scorer.evaluate_hand(hand) }

    context 'high card' do
      let(:hand) { '23456' }

      it { is_expected.to eq(0) }
    end

    context 'pair' do
      let(:hand) { 'KK324' }

      it { is_expected.to eq(1) }
    end

    context 'two pair' do
      let(:hand) { '22QKK' }

      it { is_expected.to eq(2) }
    end

    context 'three of a kind' do
      let(:hand) { 'K2K3K' }

      it { is_expected.to eq(3) }
    end

    context 'full house' do
      let(:hand) { 'JKJKJ' }

      it { is_expected.to eq(4) }
    end

    context 'four of a kind' do
      let(:hand) { 'KK1KK' }

      it { is_expected.to eq(5) }
    end

    context 'five of a kind' do
      let(:hand) { 'AAAAA' }

      it { is_expected.to eq(6) }
    end

    context 'when J cards are wild' do
      let(:wild_j) { true }

      context 'high card' do
        let(:hand) { '23456' }

        it { is_expected.to eq(0) }
      end
    end
  end

  describe '#winnings' do
    subject { scorer.winnings }

    it 'returns the sum for the bid * rank of each hand' do
      expect(subject).to eq(6440)
    end

    context "with input data" do
      let(:test_input) { File.read('./inputs/d7.txt') }

      it { is_expected.to eq 246163188 }
    end

    context "with J wildcards" do
      let(:wild_j) { true }

      it { is_expected.to eq 5905 }

      context "with input data" do
        let(:test_input) { File.read('./inputs/d7.txt') }

        it { is_expected.to eq 245794069 }
      end
    end
  end
end
