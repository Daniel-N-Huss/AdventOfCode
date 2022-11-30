require 'rspec'
require_relative '../solutions/d7'

describe FuelSaver do
  let(:test_positions) { "16,1,2,0,4,2,7,1,2,14" }

  describe "minimum_fuel_cost" do
    subject { fuel_saver.minimum_fuel_cost }
    let(:fuel_saver) { FuelSaver.new(test_positions) }

    it { is_expected.to eq 168 }
  end

  describe "scaling_distance_costs" do
    subject { fuel_saver.scaling_distance_costs }
    let(:fuel_saver) { FuelSaver.new(test_positions) }
    let(:test_positions) { "2,0,4,2,5" }

    it "calculates the cost of moving distances to the maximum range in the sample data" do
      expect(subject).to eq({0 => 0, 1 => 1, 2 => 3, 3 => 6, 4 => 10, 5 => 15})
    end
  end
end
