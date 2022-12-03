require 'rspec'
require_relative '../../solutions/d3'

RSpec.describe RucksackPacker do

  let(:packing_list) { "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw" }

  describe "priority_of_mispacked_items" do
    subject { RucksackPacker.new(packing_list).priority_of_mispacked_items }

    it { is_expected.to eq 157 }
  end

  describe "badge_item_priority" do
    subject { RucksackPacker.new(packing_list).badge_item_priority }

    it { is_expected.to eq 70 }
  end
end
