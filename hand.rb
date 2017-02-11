
class Hand

  attr_accessor :hand, :split_number

  def initialize(split_number=0)
    @hand = []
    @split_number = split_number
  end

  def player_show_hand(pretext="Your hand is: ")
    if split_number == 0
      puts pretext
      hand.each do |card|
        puts card
      end
      puts "Your current score is #{hand_value}"
    else
      puts "Split hand ##{split_number} is: "
      hand.each do |card|
        puts card
      end
      puts "Your current score is #{hand_value}"
    end
    puts
  end

  def cpu_show_hand
    puts "The house is showing: "
    hand[1..-1].each do |card|
      puts card
    end
    puts
  end

  def hand_value
    hand.collect(&:value).reduce(:+)
  end

  def bust?
    hand_value > 21
  end

  def hand_wins?(other)
    return false if bust?
    return true if other.bust?
    hand_value == 21 || (hand_value > other.hand_value) || hand.count > 5 || ((hand_value == other.hand_value) && (hand.count >= other.hand.count))
  end

  def to_s
    "Hand #{split_number}"
  end

end
