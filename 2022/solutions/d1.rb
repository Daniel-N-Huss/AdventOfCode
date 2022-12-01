class CalorieCount
  def initialize(calorie_list)
    @calorie_list = calorie_list.split("\n\n").collect { |elf_list| elf_list.split("\n").collect(&:to_i) }
  end

  def highest_calories
    @calorie_list.collect(&:sum).max
  end

  def top_three_calories
    @calorie_list.collect(&:sum).sort.reverse.take(3).sum
  end
end



input = File.open(File.absolute_path("./2022/inputs/d1.txt")).read

calorie_counter = CalorieCount.new(input)
# puts calorie_counter.highest_calories
puts calorie_counter.top_three_calories