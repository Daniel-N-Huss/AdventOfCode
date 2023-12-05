require_relative '../solutions/d5'

RSpec.describe IslandIslandAlminac do
  let(:test_data) do
    <<~DATA
      seeds: 79 14 55 13

      seed-to-soil map:
      50 98 2
      52 50 48

      soil-to-fertilizer map:
      0 15 37
      37 52 2
      39 0 15

      fertilizer-to-water map:
      49 53 8
      0 11 42
      42 0 7
      57 7 4

      water-to-light map:
      88 18 7
      18 25 70

      light-to-temperature map:
      45 77 23
      81 45 19
      68 64 13

      temperature-to-humidity map:
      0 69 1
      1 0 69

      humidity-to-location map:
      60 56 37
      56 93 4
    DATA
  end

  describe '#initialize' do
    subject { IslandIslandAlminac.new(test_data) }

    it { is_expected.to be_a IslandIslandAlminac }
  end

  describe '#parse_input' do
    let(:alminac) { IslandIslandAlminac.new(test_data) }

    subject { alminac.parse_input }

    it 'splits input data into individual location maps' do
      expect(subject).to eq(
        { 'fertilizer-to-water' => [[49, 53, 8], [0, 11, 42], [42, 0, 7], [57, 7, 4]],
          'humidity-to-location' => [[60, 56, 37], [56, 93, 4]],
          'light-to-temperature' => [[45, 77, 23], [81, 45, 19], [68, 64, 13]],
          'seed-to-soil' => [[50, 98, 2], [52, 50, 48]],
          'soil-to-fertilizer' => [[0, 15, 37], [37, 52, 2], [39, 0, 15]],
          'temperature-to-humidity' => [[0, 69, 1], [1, 0, 69]],
          'water-to-light' => [[88, 18, 7], [18, 25, 70]] }
      )

      expect(alminac.seeds).to eq([79, 14, 55, 13])
    end
  end

  describe "#maps" do
    let(:alminac) { IslandIslandAlminac.new(test_data) }

    subject { alminac.maps }

    it "converts mappings into AlminacMap lookups" do
      expect(subject['fertilizer-to-water']).to be_a IslandIslandAlminac::AlminacMap
      expect(subject['fertilizer-to-water'].convert(53)).to eq 49

      expect(subject['humidity-to-location']).to be_a IslandIslandAlminac::AlminacMap
      expect(subject['light-to-temperature']).to be_a IslandIslandAlminac::AlminacMap
      expect(subject['seed-to-soil']).to be_a IslandIslandAlminac::AlminacMap
      expect(subject['soil-to-fertilizer']).to be_a IslandIslandAlminac::AlminacMap
      expect(subject['temperature-to-humidity']).to be_a IslandIslandAlminac::AlminacMap
      expect(subject['water-to-light']).to be_a IslandIslandAlminac::AlminacMap
    end
  end

  describe "nearest_seed_location" do
    subject { IslandIslandAlminac.new(test_data).nearest_seed_location }

    it "converts seed data to locations, and returns the smallest distance" do
      expect(subject).to eq 35
    end

    context "with input data" do
      let(:test_data) { File.read("./inputs/d5.txt") }

      it { is_expected.to eq 331445006 }
    end
  end

  describe IslandIslandAlminac::AlminacMap do

    let(:mappings) { [[42, 0, 7]] }

    describe "#initialize" do
      subject { IslandIslandAlminac::AlminacMap.new(mappings) }

      let(:mappings) { [[42, 0, 3], [90, 33, 2]] }

      it "creates conversion hashes to indicate conversions ranges" do
        expect(subject.conversion_ranges).to eq(
          {
            0 => { conversions: {}, range_length: 3, source_range_min: 0,
              source_range_max: 2, destination_range_min: 42, destination_range_max: 44 },
            33 => { conversions: {}, range_length: 2, source_range_min: 33,
              source_range_max: 34, destination_range_min: 90, destination_range_max: 91 }
          }
        )
      end
    end

    context "#convert" do
      let(:alminac) { IslandIslandAlminac::AlminacMap.new(mappings) }

      context "when a conversion exists in the range" do
        it "returns the conversion" do
          expect(alminac.convert(0)).to eq 42
          expect(alminac.convert(1)).to eq 43
          expect(alminac.convert(6)).to eq 48
        end
      end

      context "when a conversion does not exist" do
        it "returns the source value" do
          expect(alminac.convert(99)).to eq 99
          expect(alminac.convert(99000)).to eq 99000
        end
      end
    end
  end
end