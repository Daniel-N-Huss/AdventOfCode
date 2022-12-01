require 'rspec'
require_relative '../../solutions/d1'

describe CalorieCount do
  let(:test_input) do
    "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"
  end

  let(:calorie_count) { CalorieCount.new(test_input) }

  describe "highest_calories" do
    subject { calorie_count.highest_calories }

    it { is_expected.to eq 24000 }
  end

  describe "top_three_calories" do
    subject { calorie_count.top_three_calories }

    it { is_expected.to eq 45000 }
  end
end
