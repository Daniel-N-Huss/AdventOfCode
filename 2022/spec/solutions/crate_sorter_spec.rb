require 'rspec'
require_relative '../../solutions/d5'

RSpec.describe CrateSorter do

  let(:crate_list) do
    "    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"
  end

  describe 'sort_by_instruction' do
    subject { CrateSorter.new(crate_list).sort_by_instruction }

    it { is_expected.to eq 'CMZ' }
  end

  describe 'group_sort_by_instruction' do
    subject { CrateSorter.new(crate_list).group_sort_by_instruction }

    it { is_expected.to eq 'MCD' }
  end
end