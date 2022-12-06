class SignalDecode
  def initialize(signal)
    @signal = signal.chars
  end

  def start_of_packet_position
    @signal.each_with_index do |char, index|
      next if index < 3

      if @signal[index - 3..index].uniq.count == 4
        return index + 1
      end
    end
  end

  def start_of_message_position
    @signal.each_with_index do |char, index|
      next if index < 13

      if @signal[index - 13..index].uniq.count == 14
        return index + 1
      end
    end
  end
end

input = File.open(File.absolute_path("./2022/inputs/d6.txt")).read
#
# puts SignalDecode.new(input).start_of_packet_position
puts SignalDecode.new(input).start_of_message_position