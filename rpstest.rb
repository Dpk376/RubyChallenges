require 'minitest/autorun'
require_relative './rpstest'  # Replace 'rps_game' with the actual filename

class TestRockPaperScissors < Minitest::Test
  def setup
    @game = RockPaperScissors.new
  end

  def test_valid_user_input_rock
    @game.stub(:gets, "Rock\n") do
      assert_output(/Computer chose/) { @game.play }
    end
  end

  def test_valid_user_input_paper
    @game.stub(:gets, "Paper\n") do
      assert_output(/Computer chose/) { @game.play }
    end
  end

  def test_valid_user_input_scissors
    @game.stub(:gets, "Scissors\n") do
      assert_output(/Computer chose/) { @game.play }
    end
  end


  def test_invalid_user_input
    input_sequence = ["Invalid\n", "Invalid\n", "Invalid\n", "Rock\n"]
    @game.stub(:gets, input_sequence.join) do
      assert_output(/Invalid choice.*Please enter Rock, Paper, or Scissors/) { @game.play }
    end
  end
  

  def test_play_again
    input_sequence = ["Rock\n", "yes\n", "Scissors\n", "no\n"]
    @game.stub(:gets, input_sequence.join) do
      assert_output(/Thanks for playing/) { @game.play }
    end
  end
end
