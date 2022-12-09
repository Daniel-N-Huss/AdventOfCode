require 'rspec'
require_relative '../../solutions/d8'

RSpec.describe TreeFarm do

  let(:tree_map) do
    "30373
25512
65332
33549
35390"
  end

  let(:tree_farm) { TreeFarm.new(tree_map) }

  describe "count_visible_trees" do
    subject { tree_farm.count_visible_trees }

    it { is_expected.to eq 21 }
  end
end