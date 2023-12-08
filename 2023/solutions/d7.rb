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
      cards1 = hand1.first
      cards2 = hand2.first

      cards1_strength = evaluate_hand(cards1)
      cards2_strength = evaluate_hand(cards2)

      if cards1_strength == cards2_strength
        tiebreak(cards1, cards2)
      else
        cards1_strength - cards2_strength
      end
    end
  end

  def evaluate_hand(cards)
    card_types = cards.split('').uniq

    type_count = card_types.count
    wild_count = cards.count('J')
    highest_type_count = highest_type_count(card_types, cards)

    return 6 if type_count == 1 # 5 of a kind

    if @wild_j && wild_count >= 1
      score_wildcard_hand(type_count, highest_type_count, wild_count)
    else
      score_hand(highest_type_count, type_count)
    end
  end

  def winnings
    @hands = parse_input
    @hands = sort_hands_by_strength
    @hands.each_with_index.reduce(0) { |memo, (hand, rank)| memo + (hand[1] * (rank + 1)) }
  end

  private

  def tiebreak(cards1, cards2)
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
  end

  def highest_type_count(card_types, cards)
    card_types.map do |type|
      cards.count(type)
    end.max
  end

  def score_hand(highest_type_count, type_count)
    case type_count
    when 2
      if highest_type_count == 4
        5 # 4 of a kind
      else
        4 # full house
      end
    when 3
      # 3 of a kind, or two pair
      highest_type_count
    when 4
      1 # pair
    else
      0 # high card
    end
  end

  def score_wildcard_hand(type_count, highest_type_count, wild_count)
    case type_count
    when 2
      6 # 5 of a kind
    when 3
      if !(highest_type_count == 2 && wild_count == 1)
        5 # 4 of a kind
      else
        4 # full house
      end
    when 4
      3 # 3 of a kind
    else
      1 # pair
    end
  end
end
