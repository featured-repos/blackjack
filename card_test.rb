require 'minitest/autorun'
require_relative 'card'

class CardTest < MiniTest::Test

  def test_a_card_has_a_face
    card = Card.new("7", "Spades")
    assert_equal "7", card.face
  end

  def test_a_card_has_a_suit
    card = Card.new("Ace", "Diamonds")
    assert_equal "Diamonds", card.suit
  end

  def test_a_card_has_a_value
    new_card = Card.new("10", "Clubs")
    assert_equal 10, new_card.value
  end

  def test_a_card_can_be_compared
    card1 = Card.new("10", "Clubs")
    card2 = Card.new("5", "Hearts")
    assert card1 > card2
  end

end
