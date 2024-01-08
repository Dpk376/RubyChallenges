class RockPaperScissors
  def initialize
    @choices = ["Rock", "Paper", "Scissors"]
  end

  def play
    puts "Welcome to Rock, Paper, Scissors!"

    loop do
      user_choice = get_user_choice
      break unless user_choice

      computer_choice = get_computer_choice

      puts "Computer chose #{computer_choice}"
      determine_winner(user_choice, computer_choice)

      puts "Do you want to play again? (yes/no)"
      play_again = gets.chomp.downcase
      break unless play_again == 'yes'
    end

    puts "Thanks for playing Rock, Paper, Scissors! Goodbye!"
  end

  private

  def get_user_choice
    invalid_attempts = 0

    loop do
      puts "Enter your choice (Rock, Paper, or Scissors):"
      user_choice = gets.chomp.capitalize

      return user_choice if @choices.include?(user_choice)

      puts "Invalid choice. Please enter Rock, Paper, or Scissors."

      invalid_attempts += 1
      return nil if invalid_attempts >= 3  # Allow 3 invalid attempts
    end
  end

  def get_computer_choice
    @choices.sample
  end

  def determine_winner(user_choice, computer_choice)
    if user_choice == computer_choice
      puts "It's a tie!"
    elsif (user_choice == "Rock" && computer_choice == "Scissors") ||
          (user_choice == "Scissors" && computer_choice == "Paper") ||
          (user_choice == "Paper" && computer_choice == "Rock")
      puts "You win! #{user_choice} beats #{computer_choice}."
    else
      puts "You lose! #{computer_choice} beats #{user_choice}."
    end
  end
end


