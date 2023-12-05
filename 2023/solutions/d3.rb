class EngineSchematic

  def initialize(raw_schematic_data, gears: false)
    @raw_schematic_data = raw_schematic_data
    @schematic_line_length = nil
    @gears = gears

    @lookup = parse_input
  end

  def parse_input
    lookup = Hash.new('.')

    matrix = @raw_schematic_data.split("\n").map { |line| line.split("") }

    @schematic_line_length = matrix.first.length

    matrix.each_with_index do |row, row_index|
      row.each_with_index do |char, char_index|
        lookup["#{row_index},#{char_index}"] = char
      end
    end

    lookup
  end

  def find_parts
    part_matcher = @gears ? /\*/ : /[^0-9.]/

    @coords ||= @lookup.dup.map do |k, v|
      k if v.match?(part_matcher)
    end.compact
  end

  def fetch_part_numbers
    find_parts.map do |coord|
      x, y = coord.split(",").map(&:to_i)

      left = x - 1
      right = x + 1
      up = y - 1
      down = y + 1

      ul = [left, up]
      u = [x, up]
      ur = [right, up]
      l = [left, y]
      r = [right, y]
      dl = [left, down]
      d = [x, down]
      dr = [right, down]

      possible_matches = []

      [ul, u, ur, l, r, dl, d, dr].each do |unvalidated_coords|

        possible_x = unvalidated_coords[0]
        possible_y = unvalidated_coords[1]

        next unless @lookup["#{possible_x},#{possible_y}"].match?(/[0-9]/)
        part_number = @lookup["#{possible_x},#{possible_y}"].dup

        (possible_y - 1).downto(0).each do |jjj|
          if @lookup["#{possible_x},#{jjj}"].match?(/[0-9]/)
            part_number.prepend(@lookup["#{possible_x},#{jjj}"])
          else
            break
          end
        end

        ((possible_y + 1)..@schematic_line_length).each do |jjj|
          if @lookup["#{possible_x},#{jjj}"].match?(/[0-9]/)
            part_number << @lookup["#{possible_x},#{jjj}"]
          else
            break
          end
        end

        possible_matches << part_number.to_i
      end

      matches = possible_matches.uniq
      if @gears
        if matches.count == 2
          matches.inject(1, :*)
        else
          []
        end
      else
        matches.flatten
      end
    end.flatten
  end

  def sum_part_numbers
    fetch_part_numbers.sum
  end
end
