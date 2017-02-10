require_relative 'card'

class Deck

  attr_accessor :cards

  def initialize(num=1)
    suits = %w(Spades Hearts Clubs Diamonds)
    faces = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
    self.cards = []
    num.times do
      self.cards += faces.product(suits).collect { |face, suit| Card.new(face, suit) }
    end
    cards.shuffle!
  end

  def draw
    cards.shift
  end

  def empty?
    cards.empty?
  end

  def reshuffle(cards_won)
    self.cards += cards_won
    self.cards.shuffle!
  end


  # def make_a_deck_of_cards
  #   suits = %w(spades hearts clubs diamonds)
  #   faces = %w(2 3 4 5 6 7 8 9 10 jack queen king ace)
  #   @cards = faces.product(suits).collect { |face, suit| Card.new(face, suit) }
    # @cards = suits.collect do |suit|
    #          faces.collect do |face|
    #            Card.new(face, suit)
    #             end
    #             end
    # @cards.flatten!
  # end



end
