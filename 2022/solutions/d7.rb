class Terminal
  def initialize(terminal_log)
    @terminal_log = terminal_log.split("\n")
    @home = Directory.new('/', nil)
    @current_directory = @home

    @disk_size = 70_000_000
    @size_needed_for_update = 30_000_000
  end

  def sum_small_directories
    parse_terminal_input

    @home.total_sizes_under(100_000).sum
  end

  def smallest_possible_clear_size
    parse_terminal_input

    free_space = @disk_size - @home.total_size
    need_to_clear_for_update = @size_needed_for_update - free_space

    @home.total_sizes_over(need_to_clear_for_update).min
  end

  def parse_terminal_input
    map_directories(@terminal_log.drop(1))

    @home.calc_file_size
  end

  def map_directories(terminal_log)
    terminal_log.each do |line|
      line_phrases = line.split(' ')
      prefix = line_phrases.first
      name = line_phrases.last

      case prefix
      when '$'
        command = line_phrases[1]

        case command
        when 'cd'
          change_directory(name)
        else
          # do nothing on ls
        end

      when 'dir'
        create_directory(name)
      else
        create_file(name, prefix)
      end
    end
  end

  def change_directory(name)
    @current_directory =
      if name == '..'
        @current_directory.parent
      else
        @current_directory.children.find { |directory| directory.name == name }
      end
  end

  def create_file(name, prefix)
    file = StarFile.new(name, prefix.to_i)
    @current_directory.add_file(file)
  end

  def create_directory(name)
    new_dir = Directory.new(name, @current_directory)
    @current_directory&.children&.push(new_dir)
  end
end

class Directory
  attr_reader :name, :total_size
  attr_accessor :children, :files, :parent

  def initialize(name, parent)
    @name = name
    @parent = parent
    @children = []
    @files = []
    @total_size = 0
  end

  def add_file(file)
    @files << file
  end

  def calc_file_size
    @total_size += file_sizes(@files)

    @total_size += calc_child_directory_sizes(@children)

    @total_size
  end

  def calc_child_directory_sizes(children)
    children.map(&:calc_file_size).reduce(0, :+)
  end

  def file_sizes(files)
    files.reduce(0) { |sum, file| sum + file.size }
  end

  def total_sizes_under(max_size)
    limit_size = @total_size <= max_size ? @total_size : 0

    child_sizes = child_sizes(:total_sizes_under, max_size)

    [limit_size, child_sizes].flatten
  end

  def total_sizes_over(min_size)
    limit_size = @total_size >= min_size ? @total_size : Float::INFINITY

    child_sizes = child_sizes(:total_sizes_over, min_size)

    [limit_size, child_sizes].flatten
  end

  def child_sizes(size_by, min_size)
    @children.reduce([]) { |acc, child| acc + child.send(size_by, min_size) }
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
