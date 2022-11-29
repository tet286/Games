# Bonus features:
# 1.  Add joinor method to display available squares
# 2.  Keep score
# 3.  Computer AI: Defense

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +  # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +  # cols
                  [[1, 5, 9], [3, 5, 7]]               # diagonals

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def count_human_marker(squares)
    squares.collect(&:marker).count(TTTGame::HUMAN_MARKER)
  end

  def count_computer_marker(squares)
    squares.collect(&:marker).count(TTTGame::COMPUTER_MARKER)
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end


  def immediate_threat?
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_human_markers?(square)
        return squares.

        

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  private
  def two_identical_human_markers?(square)
    markers = squares.select(&:humnan_marked?).collect(&:marker)
    return true if markers.size == 2 && markers.include?(INITIAL_MARKER) 
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def human_marked?
    marker == HUMAN_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  WINNING_SCORE = 3
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
    @human_score = 0
    @computer_score = 0
  end

  def play
    clear
    display_welcome_message
    main_game
    display_end_result
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic-Tac-Toe!"
    puts
  end

  def display_goodbye_message
    puts "Thank you for playing Tic-Tac-Toe! Goodbye!"
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, invalid choice!"
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def main_game
    loop do
      display_board
      player_move
      display_result
      break if [@human_score, @computer_score].include?(WINNING_SCORE)
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're a #{HUMAN_MARKER}. Computer is a #{COMPUTER_MARKER}"
    puts "Remember, whoever reach #{WINNING_SCORE} wins first will win the game!"
    puts "Computer score: #{@computer_score}"
    puts "Player score: #{@human_score}"
    puts
    board.draw
    puts
  end

  def display_result
    display_board
    case board.winning_marker
    when HUMAN_MARKER
      @human_score += 1
      puts "You won this round!"
    when COMPUTER_MARKER
      @computer_score += 1
      puts "Computer won this round!"
    else
      puts "Board is full"
    end
  end

  def play_again?
    answer = ""
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts
  end

  def joinor(arr, delimeter = ',', conjunction = 'or')
    result = ''
    case arr.size
    when 1 then return "#{arr[0]}"
    when 2 then return "#{arr[0]} #{conjunction} #{arr[1]}"
    else
      arr.size.times do |i|
        if i == arr.size - 1
          result << "#{conjunction} #{arr[i]}"
        else
          result << "#{arr[i]}#{delimeter} "
        end
      end
    end
    result
  end

  def display_end_result
    clear
    puts "+--+--+--+--+--+--+--++--+--+--++--+--+--+"
    puts "Computer Score: #{@computer_score}"
    puts "Player Score: #{@human_score}"
    puts "+--+--+--+--+--+--+--++--+--+--++--+--+--+"
    if @human_score == WINNING_SCORE
      puts "Congratz! You won the game!"
    else
      puts "Sorry! Computer won the game."
    end
  end
end

game = TTTGame.new
game.play
