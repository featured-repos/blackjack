require 'tty'
require_relative 'deck'
require_relative 'card'
require_relative 'player'
require 'pry'

class Game
  include Comparable

  attr_accessor :deck, :playah, :dealah, :prompt

  def initialize
    @prompt = TTY::Prompt.new
    unless self.class.shoe_size
      puts 'How many decks would you like to shuffle into the shoe?'
      self.class.shoe_size = prompt.ask('Enter a number:', default: '1').to_i
    end
    @deck = Deck.new(self.class.shoe_size)
    @playah = Player.new
    @dealah = Player.new
    2.times do
      @playah.hand << Card.new("3", "Clubs")
      @dealah.hand << deck.draw
    end
    show_hands
    split_decision
  end

  class << self
    attr_writer :shoe_size
  end

  class << self
    attr_reader :shoe_size
  end

  class << self
    attr_writer :games_counter
  end

  def self.games_counter
    @games_counter ||= 0
  end

  class << self
    attr_writer :games_won
  end

  def self.games_won
    @games_won ||= 0
  end

  def show_hands
    playah.player_show_hand
    playah.split_show_hand unless playah.split_hand.empty?
    dealah.cpu_show_hand
    ace_decision
  end

  def split_decision
    if playah.hand.collect(&:face).uniq.length == 1
      response = prompt.yes?('Would you like to split?')
      if response
        playah.split_hand = [playah.hand.shift, deck.draw] # shift one of the original cards to a new hand
        playah.hand << deck.draw # drawing a card to complete original hand
        show_hands
      end
    end
  end

  def ace_decision
    playah.hand.select { |card| card.face == 'Ace' }
          .each do |card|
      response = prompt.select("Choose a value for your Ace of #{card.suit}", %w(1 11))
      card.value = response.to_i
    end
    playah.split_hand.select { |card| card.face == 'Ace' }
          .each do |card|
      response = prompt.select("Choose a value for your Ace of #{card.suit}", %w(1 11))
      card.value = response.to_i
    end
  end

  def autowin?
    playah.hand_value == 21 || dealah.hand_value == 21 || playah.bust? || dealah.bust?
  end

  def play
    unless autowin?
      player_hit_or_stay
      cpu_hit_or_stay
    end
    win_conditions || lose_conditions
  end

  def player_hit_or_stay
    response = prompt.select('Do you want to hit or stay?', %w(Hit Stay))
    if response == 'Hit'
      playah.hand << deck.draw
      show_hands
      win_conditions if playah.hand.count > 5 || playah.hand_value == 21
      lose_conditions if playah.bust?
      player_hit_or_stay
    end
  end

  def cpu_hit_or_stay
    dealah.hand << deck.draw until dealah.hand_value >= 16 || dealah.bust?
  end

  def win_conditions
    return unless playah.hand_value == 21 || dealah.bust? || (playah.hand_value > dealah.hand_value && !playah.bust?) || (playah.hand.count > 5 && !playah.bust) || (playah.hand_value == dealah.hand_value && playah.hand.count >= dealah.hand.count)
    puts 'You win!'
    self.class.games_won += 1
    game_over
  end

  def lose_conditions
    puts 'You lose!'
    game_over
  end

  def game_over
    self.class.games_counter += 1
    playah.player_show_hand
    dealah.player_show_hand('The house had: ')
    record_keeping
    ask_for_rematch
  end

  def record_keeping
    puts "You've played #{self.class.games_counter} games. Your record is #{self.class.games_won} wins and #{(self.class.games_counter - self.class.games_won)} losses."
  end

  def ask_for_rematch
    desire = prompt.yes?('Would you like a rematch?')
    if desire
      Game.new.play
    else
      puts 'Goodbye'
      exit
    end
  end
end

Game.new.play


# Make split_hit_or_stay method
# Make split_win_conditions method
# Add message text for split wins



# Adjust counter for split wins/losses?
# Ask if resplitting is allowed
# Ask if the assistant is counting cards, or just simple arithmetic for hit when <17
