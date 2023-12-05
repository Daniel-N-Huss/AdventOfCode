class IslandIslandAlminac
  attr_reader :seeds

  def initialize(data)
    @data = data
    @seeds = []
  end

  CONVERSION_ORDER = %w[seed-to-soil soil-to-fertilizer fertilizer-to-water water-to-light light-to-temperature
                        temperature-to-humidity humidity-to-location].freeze

  def parse_input
    charts = @data.split("\n\n")

    @seeds = charts.first.split('seeds: ').last.split(' ').map(&:to_i)

    maps = charts[1..-1]
    @setup_maps ||= maps.map do |map|
      map_name, value = map.split(" map:\n")
      charts = value.split("\n").map { |line| line.split(' ').map(&:to_i) }
      [map_name, charts]
    end.to_h
  end

  def maps
    @maps ||= parse_input.transform_values do |ranges|
      AlminacMap.new(ranges)
    end
  end

  def nearest_seed_location
    maps

    @seeds.map do |seed|
      CONVERSION_ORDER.reduce(seed) do |memo, step|
        maps[step].convert(memo)
      end
    end.min
  end

  class AlminacMap
    attr_reader :conversions, :conversion_ranges

    def initialize(charts)
      @conversion_ranges = parse_charts(charts)
    end

    def convert(source_value)
      conversion_range = @conversion_ranges.values.find do |range|
        range[:source_range_min] <= source_value && range[:source_range_max] >= source_value
      end

      if conversion_range
        conversion_range[:conversions][source_value] ||= begin
          conversion_range[:destination_range_min] + (source_value - conversion_range[:source_range_min])
        end
      else
        source_value
      end
    end

    private

    def parse_charts(charts)
      conversion_range = {}
      charts.each do |chart|
        destination, source, range_length = chart

        conversion_range[source] = {
          conversions: {},
          range_length: range_length,
          source_range_min: source,
          source_range_max: source + range_length - 1,
          destination_range_min: destination,
          destination_range_max: destination + range_length - 1
        }

      end
      conversion_range
    end
  end
end