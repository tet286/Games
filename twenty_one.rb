# twenty_one.rb
# player == user, indicate if "hit" or "stay"
# dealer == computer

SUITS = [:heart, :diamond, :spade, :club]
VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A]

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def deal_card(deck, player_cards)
  player_cards << deck.pop
end

def display_card(suit, value)
  case suit
  when :spade
    puts " _____"
    puts "|#{value} .  |"
    puts '| /.\ |'
    puts "|(_._)|"
    puts "|  |  |"
    puts "|____V|"
  when :diamond
    puts " _____"
    puts "|#{value} ^  |"
    puts '| / \ |'
    puts '| \ / |'
    puts "|  .  |"
    puts "|____V|"
  when :club
    puts " _____"
    puts "|#{value} _  |"
    puts "| ( ) |"
    puts "|(_'_)|"
    puts "|  |  |"
    puts "|____V|"
  when :heart
    puts " _____"
    puts "|#{value}_ _ |"
    puts "|( v )|"
    puts '| \ / |'
    puts "|  .  |"
    puts "|____V|"
  end
end

def score(cards)
  sum = 0
  cards.each do |card|
    sum += card_value(card[1])
  end
  sum = correct_ace(cards, sum)
end

def card_value(card)
  case card
  when :A then 11
  when :K then 10
  when :Q then 10
  when :J then 10
  else card
  end
end

def correct_ace(cards, sum)
  cards.select { |card| card[1] == :A }.count.times do
    sum -= 10 if sum > 21
  end
  sum
end

def busted?(score)
  score > 21
end

def display_result(dealer_score, player_score, point)
  if dealer_score == player_score
    prompt "It's a tie!"
  elsif dealer_score > player_score
    prompt "Dealer won!"
    point[1] += 1
  else
    prompt "Player won!"
    point[0] += 1
  end
  point
end

def display_point(point)
  puts "-------------"
  prompt "Player has #{point[0]} out of 3 points"
  prompt "Dealer has #{point[1]} out of 3 points"
  puts "-------------"
end

def play_again?
  prompt "Are you ready for the next round? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

# main program:
point = [0, 0] # [player point, dealer point]
target_point = 3

loop do
  # clear screen
  print "\033[2J\033[H"

  prompt "Welcome to Twenty-One!"
  prompt "Whoever reaches 3 points first win the game. Good luck!"
  deck = initialize_deck

  player_cards = []
  dealer_cards = []

  2.times do
    deal_card(deck, player_cards)
    deal_card(deck, dealer_cards)
  end

  prompt "Your cards are: "
  player_cards.each { |card| display_card(card[0], card[1]) }

  puts "\n"
  prompt "One of your dealer cards is: "
  display_card(dealer_cards[0][0], dealer_cards[0][1])

  player_score = score(player_cards)
  puts "\n"
  prompt "Your current card score is #{player_score}"

  # player/ user turn:
  answer = nil
  loop do
    prompt "Would you like to (h)it or (s)tay? (h/s)"
    answer = gets.chomp.downcase
    break if answer == 's'
    deal_card(deck, player_cards)
    player_score = score(player_cards)
    prompt "Your cards are now: #{player_cards}"
    prompt "Your current card score is now : #{player_score}"
    break if busted?(player_score)
  end

  if busted?(player_score)
    puts "-------------"
    prompt "You're busted! Dealer wins this round!"
    point[1] += 1
    display_point(point, target_point)
    break if point.include?(target_point)
    play_again? ? next : break
  else
    prompt "You chose to stay at #{player_score}"
  end

  # Dealer turn: card has to be >= 17
  puts "-------------"
  prompt "Dealer's turn..."
  dealer_score = score(dealer_cards)
  loop do
    break if dealer_score >= 17
    prompt "Dealer hits!"
    deal_card(deck, dealer_cards)
    dealer_score = score(dealer_cards)
    prompt "Dealer cards are now: #{dealer_cards}"
    break if busted?(dealer_score)
  end

  if busted?(dealer_score)
    puts "-------------"
    prompt "Dealer's busted! Player wins this round!"
    point[0] += 1
    display_point(point, target_point)
    break if point.include?(target_point)
    play_again? ? next : break
  else
    prompt "Dealer stays at #{dealer_score}"
  end

  puts "=============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_score}"
  prompt "You have #{player_cards}, for a total of: #{player_score}"
  puts "=============="

  point = display_result(dealer_score, player_score, point)
  display_point(point, target_point)
  break if point.include?(target_point)

  play_again?
end

if point[0] == target_point
  prompt "Congratulation! You are the winner!"
else
  prompt "Dealer is the winner!"
end
prompt "Thank you for playing Twenty-One! Goodbye!"
