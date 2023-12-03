require_relative '../solutions/d2'

RSpec.describe CubeBag do
  let(:test_games) do
    <<~TEST_GAMES
      Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
      Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
      Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
      Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    TEST_GAMES
  end

  describe "#initialize" do
    it "should create a new instance of the CubeBag class" do
      expect(CubeBag.new(test_games)).to be_a CubeBag
    end
  end

  describe "#played_games" do
    let(:cube_bag) { CubeBag.new(test_games) }

    subject { cube_bag.played_games }

    it "should return a hash of games played" do
      cube_bag.parse_played_games

      expect(subject).to be_a Array
      expect(subject.count).to eq(5)
      expect(subject[0]).to be_a Hash
      expect(subject[0][:pulls]).to eq([["3 blue", "4 red"], ["1 red", "2 green", "6 blue"], ["2 green"]])
    end
  end

  describe "#max_pulled_cubes" do
    let(:cube_bag) { CubeBag.new(test_games) }

    subject { cube_bag.max_pulled_cubes }

    it "should return the maximum number of cubes pulled in a single game" do
      cube_bag.parse_played_games

      expect(subject).to be_a Array
      expect(subject.count).to eq(5)
      expect(subject[0]).to eq({ blue: 6, red: 4, green: 2 })
    end
  end

  describe "#valid_games" do
    let(:cube_bag) { CubeBag.new(test_games) }

    subject { cube_bag.valid_games }

    it "should return the invalid games" do
      cube_bag.parse_played_games

      expect(subject).to eq(8)
    end

    context "with a subset of input data" do
      let(:test_games) do
        <<~TEST_GAMES
          Game 1: 7 red, 14 blue; 2 blue, 3 red, 3 green; 4 green, 12 blue, 15 red; 3 green, 12 blue, 3 red; 11 red, 2 green
          Game 2: 16 blue, 9 red, 5 green; 8 red; 8 blue, 5 green, 12 red; 11 blue, 8 green, 17 red
          Game 3: 8 green, 1 blue, 7 red; 12 red, 6 blue, 9 green; 2 blue, 1 red, 14 green; 9 green, 4 red; 2 red, 1 blue, 8 green
          Game 4: 1 blue, 3 green; 2 green, 1 blue, 1 red; 1 red, 3 green
          Game 5: 6 red, 1 blue; 1 green; 5 red, 2 green; 1 red, 1 blue, 3 green
        TEST_GAMES
      end

      it "should return the invalid games" do
        cube_bag.parse_played_games

        expect(subject).to eq([4, 5].sum)
      end
    end

    context "with all game input" do
      let(:test_games) { File.read("./inputs/d2.txt") }

      it "should return the invalid games" do
        cube_bag.parse_played_games

        expect(subject).to eq(2204)
      end
    end
  end

  describe "#power_of_minimum_dice" do
    let(:cube_bag) { CubeBag.new(test_games) }

    subject { cube_bag.power_of_minimum_dice }

    it "should return the power of the minimum dice" do
      cube_bag.parse_played_games

      expect(subject).to eq(2286)
    end

    context "with a subset of input data" do
      let(:test_games) do
        <<~TEST_GAMES
          Game 1: 7 red, 14 blue; 2 blue, 3 red, 3 green; 4 green, 12 blue, 15 red; 3 green, 12 blue, 3 red; 11 red, 2 green
          Game 2: 16 blue, 9 red, 5 green; 8 red; 8 blue, 5 green, 12 red; 11 blue, 8 green, 17 red
          Game 3: 8 green, 1 blue, 7 red; 12 red, 6 blue, 9 green; 2 blue, 1 red, 14 green; 9 green, 4 red; 2 red, 1 blue, 8 green
        TEST_GAMES
      end

      it "should return the power of the minimum dice" do
        cube_bag.parse_played_games

        expect(subject).to eq((15 * 14 * 4) + (17 * 8 * 16) + (12 * 14 * 6))
      end
    end

    context "with all game input" do
      let(:test_games) { File.read("./inputs/d2.txt") }

      it "should return the power of the minimum dice" do
        cube_bag.parse_played_games

        expect(subject).to eq(71036)
      end
    end
  end
end