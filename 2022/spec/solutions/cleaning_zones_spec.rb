require 'rspec'
require_relative '../../solutions/d4'

RSpec.describe CleaningZones do
  let(:zone_assignments) do
    "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"
  end

  describe 'count_full_overlapping_assignment' do
    subject { CleaningZones.new(zone_assignments).count_full_overlapping_assignments }

    it { is_expected.to eq 2 }
  end

  describe 'count_partial_overlapping_assignments' do
    subject { CleaningZones.new(zone_assignments).count_partial_overlapping_assignments }

    it { is_expected.to eq 4 }
  end
end
