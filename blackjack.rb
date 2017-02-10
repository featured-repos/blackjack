require 'tty'
require_relative 'deck'
require_relative 'card'
require_relative 'player'
require 'pry'

class Game

  include Comparable

  attr_accessor :deck, :playah, :dealah, :games_counter, :prompt

  def initialize
    @deck = Deck.new
    @prompt = TTY::Prompt.new
    @playah = Player.new
    @dealah = Player.new
    2.times do
      @playah.hand << deck.draw
      @dealah.hand << deck.draw
    end
    @games_counter = 0
  end

  def show_hands
    playah.player_show_hand
    dealah.cpu_show_hand
  end

  def autowin?
    playah.hand_value == 21 || dealah.hand_value == 21 || playah.bust? || dealah.bust?
  end

  def play
    unless autowin?
      player_hit_or_stay
      cpu_hit_or_stay
    end
    win_conditions || lose_conitions
  end

  def player_hit_or_stay
    show_hands
    response = prompt.select("Do you want to hit or stay?", %w(Hit Stay))
    if response == "Hit"
      playah.hand << deck.draw
      win_conditions if playah.hand.count > 5 || playah.hand_value == 21
      lose_conditions if playah.bust?
      player_hit_or_stay
    end
  end

  def cpu_hit_or_stay
    until dealah.hand_value >= 16 || dealah.bust?
      dealah.hand << deck.draw
    end
  end

  def win_conditions
    return unless playah.hand_value == 21 || dealah.bust? || (playah.hand_value > dealah.hand_value && !playah.bust?) || (playah.hand.count > 5 && !playah.bust) || (playah.hand_value == dealah.hand_value && playah.hand.count >= dealah.hand.count)
    puts "You win!"
    game_over
  end

  def lose_conditions
    puts "You lose!"
    game_over
  end

  def game_over
    @games_counter += 1
    playah.player_show_hand
    dealah.player_show_hand("The house had: ")
    ask_for_rematch
  end

  def ask_for_rematch
    desire = prompt.yes?("Would you like a rematch?")
    if desire
      Game.new.play
    else
      puts "Goodbye"
      exit
    end
  end


end


Game.new.play
