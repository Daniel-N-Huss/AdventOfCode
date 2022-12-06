class CrateSorter
  def initialize(crate_list)
    @crate_list = crate_list.split("\n")
    @stacks, @instructions = parse_list(@crate_list)
  end

  def sort_by_instruction
    @instructions.each do |instruction|
      crates_to_move = instruction.first
      from = instruction[1]
      to = instruction.last

      crates_to_move.times do
        grab_crate = @stacks[from].pop
        @stacks[to].push(grab_crate)
      end

    end

    @stacks.values.map(&:last).join
  end

  def group_sort_by_instruction
    @instructions.each do |instruction|
      crates_to_move = instruction.first
      from = instruction[1]
      to = instruction.last

      grab_crate = @stacks[from].pop(crates_to_move)
      @stacks[to].concat(grab_crate)
    end

    @stacks.values.map(&:last).join
  end

  def parse_list(crate_list)
    instruction_delimiter = crate_list.find_index('')

    stacks = crate_list.slice(0..(instruction_delimiter - 1))
    instructions = crate_list.slice((instruction_delimiter + 1)..-1)

    instructions = instructions.map do |instruction|
      instruction.gsub('move', '').gsub('from', '').gsub('to', '').strip.split(' ').collect(&:to_i)
    end

    hash_stacks = Hash.new

    stack_numbers = stacks.pop.gsub(' ', '').chars.map(&:to_i)
    stack_numbers.each do |column|
      hash_stacks[column] = []
    end

    stacks = stacks.map do |stack|
      stack.gsub("    ", "~ ").gsub(/[ \[\]]/, '').chars
    end


    stacks.each do |stack|
      stack.each_with_index do |crate, index|
        hash_stacks[index + 1].unshift(crate) if crate != '~'
      end
    end

    [hash_stacks, instructions]
  end
end

input = File.open(File.absolute_path("./2022/inputs/d5.txt")).read

puts CrateSorter.new(input).sort_by_instruction
puts CrateSorter.new(input).group_sort_by_instruction