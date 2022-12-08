class Terminal
  def initialize(terminal_log)
    @terminal_log = terminal_log.split("\n")
    @home = Directory.new("/", nil)
    @current_directory = @home

    @disk_size = 70000000
    @size_needed_for_update = 30000000
  end

  def sum_small_directories
    parse_terminal_input

    @home.size_without_going_over(100000).sum
  end

  def smallest_possible_clear_size
    parse_terminal_input

    free_space = @disk_size - @home.size
    need_to_clear_for_update = @size_needed_for_update - free_space

    @home.size_over_minimum(need_to_clear_for_update).sort.first
  end

  def parse_terminal_input
    @terminal_log.drop(1).each do |line|
      line_phrases = line.split(" ")
      arg = line_phrases.last

      if line[0] == "$"
        if line[2..3] == "cd"
          if arg == ".."
            @current_directory = @current_directory.parent
          else
            @current_directory = @current_directory.children.select { |directory| directory.name == arg }.first
          end
        elsif line[2..3] == "ls"
          #  do nothing
        end

      elsif line[0..2] == "dir"
        new_dir = Directory.new(arg, @current_directory)
        @current_directory&.children&.push(new_dir)
      else
        file = StarFile.new(arg, line_phrases.first.to_i)
        @current_directory.add_file(file)
      end
    end

    @home.calc_file_size
  end
end

class Directory
  attr_reader :name, :size
  attr_accessor :children, :files, :parent

  def initialize(name, parent)
    @name = name
    @parent = parent
    @children = []
    @files = []
    @size = 0
  end

  def add_file(file)
    @files << file
  end

  def calc_file_size
    @size += @files.collect { |file| file.size }.sum

    @size += @children.collect { |directory| directory.calc_file_size }.sum

    @size
  end

  def size_without_going_over(max_size)
    limit_size = @size <= max_size ? @size : 0

    child_sizes = @children.collect { |child| child.size_without_going_over(max_size) }.flatten

    [limit_size, child_sizes].flatten
  end

  def size_over_minimum(min_size)
    limit_size = @size >= min_size ? @size : Float::INFINITY

    child_sizes = @children.collect { |child| child.size_over_minimum(min_size) }.flatten

    [limit_size, child_sizes].flatten
  end
end

class StarFile
  attr_reader :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end
end

# input = File.open(File.absolute_path("./inputs/d7.txt")).read
# puts Terminal.new(input).smallest_possible_clear_size
