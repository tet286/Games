# rps_challenge.rb
# Comments incorporated

require 'yaml'
MESSAGES = YAML.load_file('messages.yml')

# DATA = [[name], [win], [lose], [ascii file]]
DATA = [
  [%w(scissors s), %w(paper lizard), %w(spock rock), %w(s.txt)],
  [%w(paper p), %w(rock spock), %w(scissors lizard), %w(p.txt)],
  [%w(rock r), %w(lizard scissors), %w(spock paper), %w(r.txt)],
  [%w(lizard l), %w(spock paper), %w(scissors rock), %w(l.txt)],
  [%w(spock sp), %w(scissors rock), %w(lizard paper), %w(sp.txt)]
]

# methods:
def prompt(key)
  message = MESSAGES[key]
  puts("=> #{message}")
end

def welcome
  prompt('banner2')
  prompt('welcome')
  prompt('banner1')
  prompt('game_rule')
  prompt('game_rule1')
  prompt('banner1')
  prompt('game_rule2')
  prompt('banner2')
end

def choice_data(choice)
  if choice.start_with?("sp")
    DATA[4]
  elsif choice.start_with?("s")
    DATA[0]
  elsif choice.start_with?("p")
    DATA[1]
  elsif choice.start_with?("r")
    DATA[2]
  elsif choice.start_with?("l")
    DATA[3]
  end
end

def display_choice(first_data, second_data)
  prompt('banner2')
  prompt('you')
  puts File.read("ascii/" + first_data[3][0])
  prompt('banner2')
  prompt('computer')
  puts File.read("ascii/" + second_data[3][0])
  prompt('banner2')
end

def win?(first_data, second)
  first_data[1].include?(second)
end

def display_result(first_data, second_data, first, second)
  if win?(first_data, second)
    prompt('win')
  elsif win?(second_data, first)
    prompt('lose')
  else
    prompt('tie')
  end
end

def score_keep(data1, choice2, score1)
  score1 += 1 if win?(data1, choice2)
  score1
end

def display_score(score1, score2)
  prompt('banner1')
  puts("=> Your score is #{score1}")
  puts("=> The computer's score is #{score2}")
  prompt('banner1')
end

# main program:
welcome
usr_score = 0
computer_score = 0

loop do
  choice = ''

  loop do
    prompt('choice')
    choice = gets().chomp().downcase

    if DATA.flatten.include?(choice)
      break
    else
      prompt('valid_choice')
    end
  end

  computer_choice = ['rock', 'paper', 'scissors'].sample()

  usr_data = choice_data(choice)
  choice = usr_data[0][0]
  computer_data = choice_data(computer_choice)
  display_choice(usr_data, computer_data)

  display_result(usr_data, computer_data, choice, computer_choice)

  usr_score = score_keep(usr_data, computer_choice, usr_score)
  computer_score = score_keep(computer_data, choice, computer_score)

  display_score(usr_score, computer_score)

  break if [usr_score, computer_score].max == 3

  prompt('game_rule2')
  prompt('banner2')

  loop do
    prompt('next_round')
    answer = gets.chomp.downcase
    break if answer == 'y'
  end

  # clear screen
  print "\033[2J\033[H"
end

if usr_score == 3
  puts File.read('ascii/unicorn.txt')
else
  puts File.read('ascii/whale.txt')
end

prompt('banner1')
prompt('thank_you_bye')
prompt('banner1')
