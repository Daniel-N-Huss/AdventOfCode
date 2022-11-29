class FishPond
  attr_accessor :lantern_fish
  def initialize(fish_ages)
    @lantern_fish = seed_fish_pond(fish_ages)
  end

  def seed_fish_pond(fish_ages)
    fish_count = Hash.new(0)
    fish_ages.split(",").each { |age| fish_count[age.to_i] += 1 }
    [fish_count[0], fish_count[1], fish_count[2], fish_count[3], fish_count[4], fish_count[5], fish_count[6], fish_count[7], fish_count[8]]
  end

  def fish_count_after_days(num_of_days)
    num_of_days.times do
      spawning = @lantern_fish.shift

      @lantern_fish[6] += spawning

      @lantern_fish << spawning
    end

    @lantern_fish.sum
  end
end

# input = File.open(File.absolute_path("./2021/inputs/d6.txt")).read
#
# puts FishPond.new(input).fish_count_after_days(256)
# puts "____"