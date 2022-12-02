require 'rspec'
require_relative '../../solutions/d2'

RSpec.describe RockPaperScissorsStrategy do
  let(:guide) do
    "A Y
B X
C Z"
  end

  let(:rps_strategy) { RockPaperScissorsStrategy.new(guide) }
  
  describe "score_following_guide" do
    subject { rps_strategy.score_following_guide }

    it { is_expected.to eq 15 }
  end

  describe "score_with_strategy" do
    subject { rps_strategy.score_with_strategy }

    it { is_expected.to eq 12 }
  end
end
