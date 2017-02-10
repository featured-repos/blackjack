
class Card

  include Comparable

  attr_accessor :face, :suit, :value

  def initialize(face, suit)
    @face = face
    @suit = suit
    @value = value_map
  end

  def value_map
    values = {
      "2" => 2,
      "3" => 3,
      "4" => 4,
      "5" => 5,
      "6" => 6,
      "7" => 7,
      "8" => 8,
      "9" => 9,
      "10" => 10,
      "Jack" => 10,
      "Queen" => 10,
      "King" => 10,
      "Ace" => 11
    }
    values[face]
  end

  def <=>(other)
    value <=> other.value
  end

  def to_s
    "#{face} of #{suit}"
  end

end
