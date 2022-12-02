class RockPaperScissorsStrategy
  THROW_SCORE = { 'X' => 1, 'Y' => 2, 'Z' => 3, 'A' => 1, 'B' => 2, 'C' => 3 }
  BEATS = { 'X' => 'C', 'Y' => 'A', 'Z' => 'B' }
  DRAWS = { 'X' => 'A', 'Y' => 'B', 'Z' => 'C' }

  LOSE = { 'A' => 'C', 'B' => 'A', 'C' => 'B', :score => 0 }
  DRAW = { 'A' => 'A', 'B' => 'B', 'C' => 'C', :score => 3 }
  WIN = { 'A' => 'B', 'B' => 'C', 'C' => 'A', :score => 6 }

  STRATEGY = { 'X' => LOSE, 'Y' => DRAW, 'Z' => WIN }

  def initialize(guide)
    @guide = guide.split("\n")
  end

  def score_following_guide
    @guide.map do |round|
      opponents_throw = round[0]
      suggested_throw = round[2]

      score = THROW_SCORE[suggested_throw]

      score +=
        if BEATS[suggested_throw] == opponents_throw
          6
        elsif DRAWS[suggested_throw] == opponents_throw
          3
        else
          0
      end

      score
    end.sum
  end

  def score_with_strategy
    @guide.map do |round|
      opponents_throw = round[0]
      strategy = STRATEGY[round[2]]

      suggested_throw = strategy[opponents_throw]

      THROW_SCORE[suggested_throw] + strategy[:score]
    end.sum
  end
end

guide = File.open(File.absolute_path("./2022/inputs/d2.txt")).read

puts RockPaperScissorsStrategy.new(guide).score_with_strategy