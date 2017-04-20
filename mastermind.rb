class Mastermind
  attr_accessor :text, :input
  attr_reader :rules, :start, :allowed_char, :feedback 
  
  @@count = 12
  @@code = %w( R B G Y )
  @@win = false
  @@give_feedback = false

  def initialize
    @board = Board.new
    @codebreaker = Player.new("Player", "codebreaker")
    @codemaker = Player.new("Computer", "codemaker")
    @text = text
    @input = input

    @start = start
    @allowed_char = allowed_char
  end

  def random_code
    (@@code += @@code).shuffle!
    @@code.slice!(4,4)
  end

  def start
    rules
    @board.show_board
    random_code
    until @@count == 0 || @@win == true
    valid_move
    feedback(@input, @@code)
    end
  end

  def rules
    text = <<-EOM
    Computer generates random code from these characters:\n
    R-red, G-green, B-blue, Y-yellow in 'RGBY' format.\n
    For example: YGGB.\n
    Your job is to guess it in 12 rounds.\n
    After each round you will receive feedback:\n
    1 - good color, and good position\n
    0 - good color, but wrong position\n
    Lack of feedback means wrong color and wrong position.\n
    HAVE FUN!\n\n
    EOM
    puts text
  end

  def valid_move 
    allowed_char = ["R", "B", "G", "Y"]
    puts "\n"
    puts "Enter your code in following format: XXXX\n"

    @text = gets.chomp
    @input = @text.upcase.split("")
    if @input == @@code
      puts "YOU WON!\nCodeMaker's code was #{@@code.join(" ")}\nCodeBreaker's code was #{@input.join(" ")}.\n"
      @@win = true
      exit
    elsif @input.join("").size < 4 || @input.join("").size > 4
      puts "! ! ! Wrong number of characters, try again!\n\n"
      @@give_feedback = false
      @@win == false
    elsif (@input.join(" ") !~ /^[RGBY ]+$/)
      puts "! ! ! Invalid character - please use only combination of #{allowed_char.join(" ")}"
      @@give_feedback = false
      @@win == false
    else
      puts "\n"
      puts "Your input was: #{@input.join(" ")}\n"
      @@give_feedback = true
      @@count -= 1
    end
  end

  def feedback(input, code)
    if @@give_feedback == true
      feedback = Array.new(input.size) { '-' }
      code2 = code.dup

      input.each_with_index do |letter, index|
        if letter == code[index]
          feedback[index] = '1'
          code2[index]    = nil
        end
      end

      input.each_with_index do |letter, index|
        next if feedback[index] == '1'
        found = code2.index(letter)
        if found
          feedback[index]  = '0'
          code2[found]     = nil
        end
      end
      puts "Your feedback : #{feedback.join(' ')}"
    end
  end

  class Board
    attr_accessor :board
    def initialize
      @board = ["-","-","-","-"]
    end
    
    def show_board
      puts " #{@board[0]} | #{@board[1]} | #{@board[2]} | #{@board[3]} \n\n"
    end
  end

  class Player
    attr_reader :name, :team
    def initialize(name, team)
      @name = name
      @team = team
    end
  end
end




game = Mastermind.new
game.start
