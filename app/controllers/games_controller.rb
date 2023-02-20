require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    count = 1
    until count > 10
      @letters << ('A'..'Z').to_a.sample
      count += 1
    end
    @letters
  end

  def score
    @suggestion = params[:suggestion]
    @grid = params[:grid]
    # @score = 0
    if test_letters == true & english?
      @answer = "Congratulations! #{@suggestion.upcase} is an English word!"
    elsif english? && test_letters == false
      @answer = "Sorry. #{@suggestion.upcase} can't be built out of #{@grid}."
    else
      @answer = "Sorry. #{@suggestion.upcase} isn't an English word."
    end
  end

  def test_letters
    suggestion_grid = @suggestion.upcase.chars
    suggestion_grid.all? do |letter|
      @grid.include?(letter)
      suggestion_grid.count(letter) <= @grid.split.count(letter)
    end
  end

  def english?
    word_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{@suggestion}").read
    word = JSON.parse(word_serialized)
    true if word['found'] == true
  end
end
