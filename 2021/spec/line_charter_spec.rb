require 'rspec'
require_relative '../solutions/d5'

describe LineCharter do
  let(:test_coordinates) do
    "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"
  end

  describe 'initialize' do
    subject { LineCharter.new(test_coordinates) }

    it 'stores raw coordinate data' do
      expect(subject.raw_coorinates_list).to eq test_coordinates
    end

    it 'parses coordinates into a list' do
      expect(subject.line_coordinates).to eq(
        [
          [[0, 9], [5, 9]],
          [[8, 0], [0, 8]],
          [[9, 4], [3, 4]],
          [[2, 2], [2, 1]],
          [[7, 0], [7, 4]],
          [[6, 4], [2, 0]],
          [[0, 9], [2, 9]],
          [[3, 4], [1, 4]],
          [[0, 0], [8, 8]],
          [[5, 5], [8, 2]]
        ]
      )
    end
  end

  describe "draw_map" do
    subject { line_chart.draw_map }
    let(:line_chart) { LineCharter.new(test_coordinates) }

    let(:test_coordinates) do
      "5,4 -> 3,4
2,2 -> 2,1
3,1 -> 2,1
1,1 -> 3,3"
    end

    it "returns a hash counting points on each coordinate" do
      expect(subject).to eq({ '5,4' => 1, '4,4' => 1, '3,4' => 1, '2,2' => 2, '2,1' => 2, '3,1' => 1, '1,1' => 1, '3,3' => 1 })
    end
  end

  describe "count_danger_locations" do
    subject { line_chart.count_danger_locations }
    let(:line_chart) { LineCharter.new(test_coordinates) }

    it { is_expected.to eq 12 }
  end
end

describe LineFactory do
  describe ".draw_line" do
    subject { LineFactory.draw_line(coordinate_pair) }

    context 'when x coordinates are the same at the start and end' do
      let(:coordinate_pair) { [[2, 2], [2, 1]] }
      it { is_expected.to be_a VerticalLine }
    end

    context 'when y coordinates are the same at the start and end' do
      let(:coordinate_pair) { [[0, 9], [5, 9]] }
      it { is_expected.to be_a HorizontalLine }
    end

    context 'when both x and y coordinates are different at start and end' do
      let(:coordinate_pair) { [[5, 5], [8, 2]] }
      it { is_expected.to be_a DiagonalLine }
    end
  end

  describe 'initialize' do
    subject { LineFactory.draw_line(coordinate_pair) }

    let(:coordinate_pair) { [[0, 9], [5, 9]] }

    it 'tracks start and end coordinates for the line' do
      expect(subject.start_coords).to eq({ x: 0, y: 9 })
      expect(subject.end_coords).to eq({ x: 5, y: 9 })
    end
  end

  describe 'all_points' do
    subject { line.all_points }

    let(:line) { LineFactory.draw_line(coordinate_pair) }

    context 'when the line is horizontal' do
      let(:coordinate_pair) { [[0, 9], [3, 9]] }

      it 'returns a list of all the points in the line' do
        expect(subject).to eq [[0, 9], [1, 9], [2, 9], [3, 9]]
      end

      context "when it's a reverse range" do
        let(:coordinate_pair) { [[3, 9], [0, 9]] }

        it "returns a list, but it's okay to be in 'backwards' order" do
          expect(subject).to eq [[0, 9], [1, 9], [2, 9], [3, 9]]
        end
      end
    end

    context 'when the line is vertical' do
      let(:coordinate_pair) { [[2, 1], [2, 4]] }

      it 'returns a list of all points in the line' do
        expect(subject).to eq [[2, 1], [2, 2], [2, 3], [2, 4]]
      end

      context "when it's a reverse range" do
        let(:coordinate_pair) { [[2, 4], [2, 1]] }

        it "returns a list, but it's okay to be in 'backwards' order" do
          expect(subject).to eq [[2, 1], [2, 2], [2, 3], [2, 4]]
        end
      end
    end

    context 'when the line is diagonal' do
      context "when x is ascending, y is descending" do
        let(:coordinate_pair) { [[5, 5], [8, 2]] }

        it 'returns a list of coordinates' do
          expect(subject).to eq [[5, 5], [6, 4], [7, 3], [8, 2]]
        end
      end

      context "when y is ascending, x is descending" do
        let(:coordinate_pair) { [[8, 2], [5, 5]] }

        it 'returns a list of coordinates' do
          expect(subject).to eq [[8, 2], [7, 3], [6, 4], [5, 5]]
        end
      end

      context "when x and y are ascending" do
        let(:coordinate_pair) { [[5, 5], [8, 8]] }

        it 'returns a list of coordinates' do
          expect(subject).to eq [[5, 5], [6, 6], [7, 7], [8, 8]]
        end
      end

      context "when x and y are descending" do
        let(:coordinate_pair) { [[8, 8], [5, 5]] }

        it 'returns a list of coordinates' do
          expect(subject).to eq [[5, 5], [6, 6], [7, 7], [8, 8]]
        end
      end
    end
  end
end
