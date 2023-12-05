require_relative '../solutions/d3'

RSpec.describe EngineSchematic do

  let(:test_data) do
    <<~TEST_DATA
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
    TEST_DATA
  end

  describe "#initialize" do
    it "should create a new instance of the EngineSchematic class" do
      expect(EngineSchematic.new(test_data)).to be_a EngineSchematic
    end
  end

  describe "#parse_input" do
    let(:test_data) do
      <<~TEST_DATA
        467..114..
        ...*.....%
        ..35..633.
      TEST_DATA
    end

    subject { EngineSchematic.new(test_data).parse_input }

    it "should return an array representing the schematic" do
      expect(subject).to eq({ "0,0" => "4", "0,1" => "6", "0,2" => "7", "0,3" => ".", "0,4" => ".", "0,5" => "1", "0,6" => "1", "0,7" => "4", "0,8" => ".", "0,9" => ".", "1,0" => ".", "1,1" => ".", "1,2" => ".", "1,3" => "*", "1,4" => ".", "1,5" => ".", "1,6" => ".", "1,7" => ".", "1,8" => ".", "1,9" => "%", "2,0" => ".", "2,1" => ".", "2,2" => "3", "2,3" => "5", "2,4" => ".", "2,5" => ".", "2,6" => "6", "2,7" => "3", "2,8" => "3", "2,9" => "." })
    end
  end

  describe "#find_parts" do
    subject { EngineSchematic.new(test_data).find_parts }

    it "should return an array of the coordinates where parts are" do
      expect(subject).to eq ["1,3", "3,6", "4,3", "5,5", "8,3", "8,5"]
    end

    context "when looking for gears" do
      subject { EngineSchematic.new(test_data, gears: true).find_parts }

      it "should only return coordinates where '*' characters are" do
        expect(subject).to eq ["1,3", "4,3", "8,5"]
      end
    end
  end

  describe "#fetch_part_numbers" do
    subject { EngineSchematic.new(test_data).fetch_part_numbers }

    it "should return an array of the part numbers" do
      expect(subject).to eq [467, 35, 633, 617, 592, 664, 598, 755]
    end

    context "when searching for gears" do
      subject { EngineSchematic.new(test_data, gears: true).fetch_part_numbers }

      it "should return an array of the two surrounding part numbers multiplied together" do
        expect(subject).to eq [467 * 35, 598 * 755]
      end
    end
  end

  describe "#sum_part_numbers" do
    subject { EngineSchematic.new(test_data).sum_part_numbers }

    it "should return the sum of the part numbers" do
      expect(subject).to eq 4361
    end

    context "with input subset" do
      let(:test_data) do
        <<~TEST_DATA
          ............830..743.......59..955.......663..........................................367...........895....899...............826...220......
          .......284.....*............*.....$...+.....*...377..................*.......419.............488...*.......*...................*..-....939..
          ....%.........976..679.461.7..........350..33.........$.380...$...151.897..........295..#......*....105.....418.............481........&....
        TEST_DATA
      end

      it "should return the sum of the part numbers" do
        expect(subject).to eq [830, 59, 955, 663, 895, 899, 826, 220, 488, 939, 976, 7, 350, 33, 151, 897, 105, 418, 481].sum
      end

      context "when searching for gears" do
        subject { EngineSchematic.new(test_data, gears: true).sum_part_numbers }

        it "should return the sum of the gear ratios" do
          expect(subject).to eq [830 * 976, 59 * 7, 663 * 33, 151 * 897, 895 * 105, 899 * 418, 826 * 481].sum
        end
      end
    end

    context "with full input" do
      let(:test_data) { File.read("./inputs/d3.txt") }

      it "should return the sum of the part numbers" do
        expect(subject).to eq 521515
      end

      context "when searching for gears" do
        subject { EngineSchematic.new(test_data, gears: true).sum_part_numbers }

        it "should return the sum of the part numbers" do
          expect(subject).to eq 69527306
        end
      end
    end
  end
end