require_relative 'deck'
require_relative 'card'
require_relative 'hand'


class Player

  attr_accessor :hands_array

  def initialize
    @hands_array = []
    draw_a_hand
  end

  def draw_a_hand
    @hands_array << Hand.new(hands_array.length)
    @hands_array[-1]
  end

  def player_show_hands
    hands_array.each do |hand|
      hand.player_show_hand
    end
  end

  def cpu_show_hand
    hands_array.each do |hand|
      hand.cpu_show_hand
    end
  end
  # def hand_value          # no longer needed d/t Hand class
  #   hand.collect(&:value).reduce(:+)
  # end


  # def split_hand_value        # no longer needed d/t Hand class
  #   split_hand.collect(&:value).reduce(:+)
  # end

end
