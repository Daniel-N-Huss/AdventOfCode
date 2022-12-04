require 'set'

class CleaningZones
  def initialize(cleaning_assignments)
    @cleaning_assignments = parse_assignments(cleaning_assignments)
  end

  def parse_assignments(cleaning_assignments)
    cleaning_assignments.split("\n").map do |assignment|
      assignment.split(",").map { |assignment| assignment.split('-').collect(&:to_i) }
    end
  end

  def count_full_overlapping_assignments
    @cleaning_assignments.collect do |assignment|
      zone_one, zone_two = create_sets(assignment)

      if zone_one.superset?(zone_two) || zone_two.superset?(zone_one)
        true
      end
    end.compact.count
  end

  def count_partial_overlapping_assignments
    @cleaning_assignments.collect do |assignment|
      zone_one, zone_two = create_sets(assignment)

      if zone_one.intersect?(zone_two)
        true
      end
    end.compact.count

  end

  def create_sets(assignment)
    first_assignment = assignment.first
    second_assignment = assignment.last

    zone_one = (first_assignment[0]..first_assignment[1]).to_set
    zone_two = (second_assignment[0]..second_assignment[1]).to_set

    [zone_one, zone_two]
  end
end

# input = File.open(File.absolute_path("./2022/inputs/d4.txt")).read
#
# puts CleaningZones.new(input).count_partial_overlapping_assignments