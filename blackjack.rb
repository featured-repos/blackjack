require 'tty'
require_relative 'deck'
require_relative 'player'
require 'pry'

class Game

  attr_accessor :deck, :playah, :dealah, :prompt

  def initialize
    @prompt = TTY::Prompt.new
    unless self.class.shoe_size
      puts 'How many decks would you like to shuffle into the shoe?'
      self.class.shoe_size = prompt.ask("Enter a number: ", default: '1').to_i
      puts
    end
    @deck = Deck.new(self.class.shoe_size)
    @playah = Player.new
    @dealah = Player.new
    2.times do
      @playah.hands_array[0].cards << deck.draw
      @dealah.hands_array[0].cards << deck.draw
    end
    show_hands
    split_decision(playah.hands_array[0])
  end

  class << self
    attr_accessor :shoe_size
    attr_writer :games_counter
    attr_writer :games_won

    def games_counter
      @games_counter ||= 0
    end

    def games_won
      @games_won ||= 0
    end
  end

  def show_hands
    playah.player_show
    dealah.cpu_show
    ace_decision
  end

  def split_decision(current_hand)
    if current_hand.cards.collect(&:face).uniq.length == 1
      response = prompt.yes?("Would you like to split? \n")
      if response
        playah.draw_a_hand.cards = [current_hand.cards.shift, deck.draw]
        current_hand.cards << deck.draw
        show_hands
      end
    end
  end

  def ace_decision
    playah.hands_array.each do |current_hand|
      current_hand.cards.select { |card| card.face == 'Ace' }      # searches for Aces
          .each do |card|
            response = prompt.select("Choose a value for your Ace of #{card.suit}", %w(1 11))
            card.value = response.to_i
          end
    end
  end

  def autowin?
    playah.hands_array[0].hand_value == 21 || dealah.hands_array[0].hand_value == 21 || playah.hands_array[0].bust? || dealah.hands_array[0].bust?
  end

  def play
    unless autowin?
      playah.hands_array.each do |current_hand|
        player_hit_or_stay(current_hand)
      end
      cpu_hit_or_stay
    end
    playah.hands_array.each do |current_hand|
      win_conditions(current_hand)
    end
    game_over
  end

  def player_hit_or_stay(current_hand)
    response = prompt.select("Do you want to hit or stay with #{current_hand}?", %w(Hit Stay))
    if response == 'Hit'
      current_hand.cards << deck.draw
      show_hands
      return if current_hand.cards.length > 5 || current_hand.hand_value == 21 || current_hand.bust?
      player_hit_or_stay(current_hand)   # cycles through hit/stay and checking 'auto' win conditions until player stays
    end
  end

  def cpu_hit_or_stay
    dealah.hands_array[0].cards << deck.draw until dealah.hands_array[0].hand_value >= 16 || dealah.hands_array[0].bust?
  end

  def win_conditions(current_hand)
    if current_hand.hand_wins?(dealah.hands_array[0])
      puts "=================== \n You won with #{current_hand}!"
      self.class.games_won += 1
    else
      puts "=================== \n You lost!"
    end
  end

  def game_over
    self.class.games_counter += playah.hands_array.length
    playah.player_show
    dealah.hands_array[0].player_show_hand('The house had: ')     # calling player_show instead of cpu_show to show ALL cards here
    record_keeping
    ask_for_rematch
  end

  def record_keeping
    puts "You've played #{self.class.games_counter} games. Your record is #{self.class.games_won} wins and #{(self.class.games_counter - self.class.games_won)} losses."
  end

  def ask_for_rematch
    response = prompt.yes?("Would you like a rematch?")
    if response
      puts "==================="
      Game.new.play
    else
      puts 'Goodbye!'
      exit
    end
  end
end

Game.new.play
