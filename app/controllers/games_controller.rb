require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (1..10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def exist?(guess)
    word_status = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{guess}").read)
    return word_status['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.upcase.count(letter) <= grid.count(letter) }
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters].tr('\", \"', '').tr('"[', '').tr(']"', '')
    if included?(@answer, @letters)
      if exist?(@answer)
        @score_message = "Congratulation! #{@answer.upcase} is a valid english word!"
      else
        @score_message = "Sorry but #{@answer.upcase} doesn't seem to be an english word..."
      end
    else
      @score_message = "Sorry but #{@answer.upcase} can't be built of #{@letters}"
    end
  end
end
