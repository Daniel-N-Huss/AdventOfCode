class RucksackPacker

  PRIORITY = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]

  def initialize(packing_list)
    @packed_rucksacks = packing_list.split("\n")
  end

  def priority_of_mispacked_items
    @packed_rucksacks.collect do |pack|
      midpoint = (pack.length / 2)
      first_compartment = pack[0..(midpoint) - 1]

      second_compartment = pack[midpoint..-1]

      mistakenly_packed_item = first_compartment.chars.intersection(second_compartment.chars).first

      PRIORITY.find_index(mistakenly_packed_item) + 1
    end.sum
  end

  def badge_item_priority
    groups = []

    (@packed_rucksacks.count / 3).times do
      groups << @packed_rucksacks.shift(3)
    end

    badges = groups.collect do |group|
      first_pack = group.first.chars
      second_pack = group[1].chars
      third_pack = group.last.chars

      common_items = first_pack.intersection(second_pack)
      other_common_items = second_pack.intersection(third_pack)

      common_items.intersection(other_common_items).first
    end

    badges.collect { |badge| PRIORITY.find_index(badge) + 1 }.sum
  end
end


# packing_list = File.open(File.absolute_path("./2022/inputs/d3.txt")).read

# rucksack_packer = RucksackPacker.new(packing_list)
# puts rucksack_packer.priority_of_mispacked_items

# puts rucksack_packer.badge_item_priority