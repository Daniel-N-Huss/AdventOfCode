class LineCharter
  attr_reader :raw_coorinates_list
  attr_accessor :line_coordinates

  def initialize(coordinates)
    @raw_coorinates_list = coordinates
    @line_coordinates = parse_raw(coordinates)
    @lines = line_coordinates.collect { |coord| Line.new(coord) }
  end

  def parse_raw(raw_coordinate_input)
    split_to_lines = raw_coordinate_input.split("\n")

    split_to_lines.collect do |line|
      line_start, line_end = line.split(' -> ')
      [get_int_coord_pair(line_start), get_int_coord_pair(line_end)]
    end

  end

  def get_int_coord_pair(coord)
    coord.split(',').collect(&:to_i)
  end

  def draw_map
    line_map = {}

    @lines.each do |line|
      points = line.all_points

      points.each do |point|
        coord = point.join(",")
        if line_map[coord]
          line_map[coord] += 1
        else
          line_map[coord] = 1
        end
      end
    end

    line_map
  end

  def count_danger_locations
    draw_map.select { |k, v| v >= 2 }.count
  end
end

class Line
  attr_accessor :start_coords, :end_coords, :direction

  DIRECTIONS = { horizontal: "HORIZONTAL", vertical: "VERTICAL", diagonal: "DIAGONAL" }

  def initialize(line_coords)
    @start_coords = parse_coords(line_coords).first
    @end_coords = parse_coords(line_coords).last
    @direction = parse_line_direction
  end

  def parse_line_direction
    @direction =
      if @start_coords[:x] == @end_coords[:x]
        DIRECTIONS[:vertical]
      elsif @start_coords[:y] == @end_coords[:y]
        DIRECTIONS[:horizontal]
      else
        DIRECTIONS[:diagonal]
      end
  end

  def parse_coords(line_coords)
    coord_list ||= line_coords.collect { |coord| { x: coord[0], y: coord[1] } }
  end

  def all_points
    line_points_list = []

    if direction == DIRECTIONS[:diagonal]
      x_ascending = start_coords[:x] < end_coords[:x]
      y_ascending = start_coords[:y] < end_coords[:y]

      x_coords = safe_range(start_coords[:x], end_coords[:x]).to_a
      y_coords = safe_range(start_coords[:y], end_coords[:y]).to_a

      y_coords.reverse! if x_ascending && !y_ascending

      x_coords.reverse! if !x_ascending && y_ascending

      x_coords.each_with_index do |x_coord, index|
        line_points_list << [x_coord, y_coords[index]]
      end
    end

    if direction == DIRECTIONS[:horizontal]
      range = safe_range(start_coords[:x], end_coords[:x])
      range.each do |x_point|
        line_points_list << [x_point, start_coords[:y]]
      end
    end

    if direction == DIRECTIONS[:vertical]
      range = safe_range(start_coords[:y], end_coords[:y])
      (range).each do |y_point|
        line_points_list << [start_coords[:x], y_point]
      end
    end

    line_points_list
  end

  def safe_range(start_coord, end_coord)
    start_coord < end_coord ? start_coord..end_coord : end_coord..start_coord
  end
end

line_coords = File.open(File.absolute_path("./2021/inputs/d5.txt")).read

puts LineCharter.new(line_coords).count_danger_locations