class TreeFarm
  def initialize(input)
    @tree_map = input.split("\n").collect { |row| row.chars.collect(&:to_i) }
  end

  def count_visible_trees

    left_view = @tree_map.map do |row|
      row.each_with_index.map do |tree, index|
        if index == 0
          tree
        else
          highest_blocker = row[0..(index - 1)].max
          tree > highest_blocker ? tree : nil
        end
      end
    end

    right_view = @tree_map.map do |row|
      reverse = row.reverse
      reverse.each_with_index.map do |tree, index|
        if index == 0
          tree
        else
          highest_blocker = reverse[0..(index - 1)].max
          tree > highest_blocker ? tree : nil
        end
      end.reverse
    end

    # puts left_view.inspect
    # puts right_view.inspect


    top_view = @tree_map.transpose.map do |column|
      column.each_with_index.map do |tree, index|
        if index == 0
          tree
        else
          highest_blocker = column[0..(index - 1)].max
          tree > highest_blocker ? tree : nil
        end
      end
    end.transpose

    bottom_view = @tree_map.reverse.transpose.map do |column|
      column.each_with_index.map do |tree, index|
        if index == 0
          tree
        else
          highest_blocker = column[0..(index - 1)].max
          tree > highest_blocker ? tree : nil
        end
      end
    end.transpose.reverse


    unified_views = left_view.each_with_index.collect do |row, row_index|
      row.each_with_index.collect do |tree, tree_index|
        tree || top_view[row_index][tree_index] || right_view[row_index][tree_index] || bottom_view[row_index][tree_index]
      end
    end

    unified_views.flatten.compact.count
  end
end


input = File.open(File.absolute_path("./inputs/d8.txt")).read

puts TreeFarm.new(input).count_visible_trees