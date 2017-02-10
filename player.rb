require_relative 'deck'
require_relative 'card'


class Player

  attr_accessor :hand

  def initialize
    @hand = []
  end

  def player_show_hand(pretext="You have: ")
    puts pretext
    hand.each do |card|
      puts card
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

end
