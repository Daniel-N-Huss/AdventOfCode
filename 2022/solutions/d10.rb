class ClockCircuit
  def initialize(readout)
    @readout = readout
    @x = 1
    @cycle = 0

    @notable_cycles = [20, 60, 100, 140, 180, 220]
    @signal_strengths = []

    @instructions = parse_readout
  end

  def notable_signal_strengths
    @instructions.each do |set|
      if set.length == 2
        set.each_with_index do |instruction, index|
          if index == 0
            @cycle += 1
            puts "during cycle #{@cycle}, x is #{@x}"

            if @notable_cycles.include?(@cycle)
              @signal_strengths << @x * @cycle
            end
          else
            @cycle += 1

            puts "during cycle #{@cycle}, x is #{@x}"

            if @notable_cycles.include?(@cycle)
              @signal_strengths << @x * @cycle
            end


            @x += instruction.to_i
          end
        end
      else
        @cycle += 1

        if @notable_cycles.include?(@cycle)
          @signal_strengths << @x * @cycle
        end

        puts "during cycle #{@cycle}, x is #{@x}"
      end
    end

    @signal_strengths.sum
  end

  def parse_readout
    @readout.split("\n").collect { |item| item.split(" ") }
  end
end

input = File.open(File.absolute_path("./inputs/d10.txt")).read

puts ClockCircuit.new(input).notable_signal_strengths