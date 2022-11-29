require 'rspec'
require_relative '../solutions/d6'

RSpec.describe FishPond do
  describe "initialize" do
    subject { FishPond.new(fish_ages) }

    let(:fish_ages) { "0, 1, 1, 2, 2, 2" }

    it "creates 9 schools of Lanternfish, counting how many have the same number of days remaining to spawn" do
      expect(subject.lantern_fish).to eq [1, 2, 3, 0, 0, 0, 0, 0, 0]
    end
  end

  describe "fish_count_after_days" do
    subject { fish_pond.fish_count_after_days(num_of_days) }
    let(:fish_pond) { FishPond.new(fish_ages) }
    let(:fish_ages) { "3,4,3,1,2" }

    context "after 18 days" do
      let(:num_of_days) { 18 }

      it { is_expected.to eq 26 }
    end

    context "after 80 days" do
      let(:num_of_days) { 80 }

      it { is_expected.to eq 5934 }
    end

    context "after 256 days" do
      let(:num_of_days) { 256 }

      it { is_expected.to eq 26984457539 }
    end
  end
end