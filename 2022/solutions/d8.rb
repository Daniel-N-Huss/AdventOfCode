class TreeFarm
  def initialize(input)
    @tree_map = input.split("\n").collect { |row| row.chars.collect(&:to_i) }
  end

  def visible_trees_from_perimiter

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

  def optimal_scenic_score
    tree_lookup = Hash.new(-1)

    @tree_map.each_with_index do |row, row_index|
      row.each_with_index do |tree, tree_index|
        tree_lookup["#{row_index}-#{tree_index}"] = tree
      end
    end

    max_score = 0

    tree_lookup.each do |location, tree_height|
      row, col = location.split("-")

      left_score = 0

      loop = true
      new_col = col.to_i - 1

      while loop
        neighbour_height = tree_lookup["#{row}-#{new_col}"]

        if neighbour_height < 0
          break
        end

        left_score += 1

        new_col -= 1

        if neighbour_height >= tree_height
          break
        end
      end

      right_score = 0

      new_col = col.to_i + 1

      while loop
        neighbour_height = tree_lookup["#{row}-#{new_col}"]

        if neighbour_height < 0
          break
        end

        right_score += 1

        new_col += 1

        if neighbour_height >= tree_height
          break
        end
      end


      top_score = 0

      new_row = row.to_i - 1

      while loop
        neighbour_height = tree_lookup["#{new_row}-#{col}"]

        if neighbour_height < 0
          break
        end

        top_score += 1

        new_row -= 1

        if neighbour_height >= tree_height
          break
        end
      end


      bottom_score = 0

      new_row = row.to_i + 1

      while loop
        neighbour_height = tree_lookup["#{new_row}-#{col}"]

        if neighbour_height < 0
          break
        end

        bottom_score += 1

        new_row += 1

        if neighbour_height >= tree_height
          break
        end
      end


      tree_score = left_score * right_score * top_score * bottom_score

      if tree_score > max_score
        max_score = tree_score
      end
    end

    max_score
  end
end

input = File.open(File.absolute_path("./inputs/d8.txt")).read

#
# puts TreeFarm.new(input).visible_trees_from_perimiter
puts TreeFarm.new(input).optimal_scenic_score
