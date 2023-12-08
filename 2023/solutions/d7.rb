class CamelCardScorer
  def initialize(hand_data, wild_j: false)
    @hands = []
    @hand_data = hand_data
    @wild_j = wild_j
  end

  def parse_input
    @hands = @hand_data.split("\n").map do |line|
      hand, rank = line.split(' ')

      [hand, rank.to_i]
    end
  end

  def sort_hands_by_strength
    @hands = parse_input
    @hands.sort do |hand1, hand2|
      cards1, _rank1 = hand1
      cards2, _rank2 = hand2

      cards1_strength = evaluate_hand(cards1)
      cards2_strength = evaluate_hand(cards2)

      if cards1_strength == cards2_strength
        order = @wild_j ? %w[J 2 3 4 5 6 7 8 9 T Q K A] : %w[2 3 4 5 6 7 8 9 T J Q K A]
        tiebreaker = 0

        (0..4).to_a.each do |i|
          c1_value = order.find_index(cards1[i])
          c2_value = order.find_index(cards2[i])

          if c1_value != c2_value
            tiebreaker = c1_value - c2_value

            break
          end
        end

        tiebreaker
      else
        cards1_strength - cards2_strength
      end
    end
  end

  def evaluate_hand(cards)
    card_types = cards.split('').uniq

    type_count = card_types.count
    wild_count = cards.count('J')

    if @wild_j && wild_count > 0

      if [1, 2].include?(type_count)
        return 6 # five of a kind
      end

      if type_count == 3
        highest_type_count = card_types.map do |type|
          cards.count(type)
        end.max

        if highest_type_count == 2 && wild_count == 1
          return 4
        end

        # ["888J5", 781], ["88844", 834], ["8887J", 582]

        return 5 # 4 of a kind
      end

      if type_count == 4
        return 3
      end

      if type_count == 5
        return 1 # pair
      end
    end

    case type_count
    when 1
      6 # five of a kind
    when 2
      most_cards_of_type = card_types.map do |type|
        cards.count(type)
      end.max

      if most_cards_of_type == 4
        5 # 4 of a kind
      else
        4 # full house
      end
    when 3
      # 3 of a kind, or two pair
      counts = card_types.map do |type|
        cards.count(type)
      end

      counts.max
    when 4
      1 # pair
    when 5
      0 # high card
    end
  end

  def winnings
    @hands = parse_input
    @hands = sort_hands_by_strength
    @hands.each_with_index.reduce(0) { |memo, (hand, rank)| memo + (hand[1] * (rank + 1)) }
  end
end
