require 'minitest/autorun'
require_relative 'deck'

class DeckTest < MiniTest::Test

  attr_accessor :card

  def test_a_deck_has_52_cards
    deck = Deck.new
    assert_equal 52, deck.cards.count
  end

  def test_a_deck_contains_13_of_each_suit
    deck = Deck.new
    suits = %w(Spades Hearts Clubs Diamonds)
    suits.each do |suit|
      assert_equal 13, deck.cards.select { |card| card.suit == suit }.count
    end
  end

  def test_a_deck_contains_four_of_each_face
    deck = Deck.new
    faces = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
    faces.each do |face|
      assert_equal 4, deck.cards.select { |card| card.face == face }.count
    end
  end

  # def test_a_deck_is_shuffled_when_created
  #   deck1 = Deck.new
  #   deck2 = Deck.new
  #   refute_equal deck1.cards, deck2.cards
  # end

end
