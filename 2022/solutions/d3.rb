class RucksackPacker

  PRIORITY = %w[no_zero_index_plz a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]

  def initialize(packing_list)
    @packed_rucksacks = packing_list.split("\n")
  end

  def priority_of_mispacked_items
    @packed_rucksacks.collect do |pack|
      pack_compartments = pack.chars.each_slice(pack.length / 2).to_a
      mistakenly_packed_item = pack_compartments.first.intersection(pack_compartments.last).first

      PRIORITY.find_index(mistakenly_packed_item)
    end.sum
  end

  def badge_item_priority
    badges = []
    @packed_rucksacks.each_slice(3) do |first_pack, second_pack, third_pack|
      badges << first_pack.chars.intersection(second_pack.chars, third_pack.chars).first
    end

    badges.collect { |badge| PRIORITY.find_index(badge) }.sum
  end
end

# packing_list = File.open(File.absolute_path("./2022/inputs/d3.txt")).read

# rucksack_packer = RucksackPacker.new(packing_list)
# puts rucksack_packer.priority_of_mispacked_items

# puts rucksack_packer.badge_item_priority