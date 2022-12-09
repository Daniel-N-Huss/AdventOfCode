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

  describe "visible_trees_from_perimiter" do
    subject { tree_farm.visible_trees_from_perimiter }

    it { is_expected.to eq 21 }
  end

  describe "optimal_viewing_tree_score" do
    subject { tree_farm.optimal_scenic_score }

    it { is_expected.to eq 8 }
  end
end