require 'set'

class Player
  attr_reader :cards, :id

  def initialize(id, cards)
    @id = id
    @cards = cards.map{|n| n.to_i }
  end

  def pop
    @cards.shift
  end
  def push(card)
    @cards.push(card)
  end
  def peek
    @cards.first
  end
  def score
    @cards.reverse.map.with_index(1) { |n,i| n*i }.reduce(:+) || 0
  end
  def empty?
    @cards.empty?
  end
  def size
    @cards.size
  end
  def cut(num_cards)
    @cards[0..num_cards-1]
  end
  def to_s
    "#{@id} #{@cards.join(",")}"
  end
end

class Game

  attr_reader :round_number

  def initialize(players)
    @player1, @player2 = players
    @round_number = 1
  end

  def game_over?
    @player1.empty? || @player2.empty?
  end

  def winner
    @player1.empty? ? @player2 : @player1
  end

  def deal
    [@player1.pop, @player2.pop]
  end

  def play
    until game_over? do
      # puts "-- Round -- #{@round_number}"
      # puts "#{@player1.id}'s player: #{@player1}"
      # puts "#{@player2.id}'s player: #{@player2}"
      winner = play_round
      #puts "#{winner.id} wins the round!"
      @round_number+=1
    end
  end

  def play_round
    p1_card, p2_card = deal
    # puts "Player 1 plays: #{p1_card}"
    # puts "Player 2 plays: #{p2_card}"
    if p1_card > p2_card
      @player1.push(p1_card)
      @player1.push(p2_card)
      return @player1
    else
      @player2.push(p2_card)
      @player2.push(p1_card)
      return @player2
    end
  end

  def to_s
    ["-- Round #{@round_number} --",
     "Player 1: #{@player1}",
     "Player 2: #{@player2}"].join("\n")
  end
end

class RecursiveCombat < Game

  def initialize(players)
    super(players)
    @previous_rounds = Set.new()
  end

  def repeated_round?
    @previous_rounds.include?(@player1.to_s + @player2.to_s)
  end

  def play
    #puts self.to_s
    # sleep(0.5)
    until game_over? || repeated_round? do
      # puts "-- Round -- #{@round_number}"
      # puts "#{@player1.id}'s player: #{@player1}"
      # puts "#{@player2.id}'s player: #{@player2}"
      winner = play_round
      # puts "#{winner.id} wins the round!"
      @round_number+=1
    end
    winner = @player1 if repeated_round?
    winner
  end

  def play_round
    @previous_rounds.add(@player1.to_s + @player2.to_s)

    p1_card, p2_card = deal
    # puts "Player 1 plays: #{p1_card}"
    # puts "Player 2 plays: #{p2_card}"

    if @player1.size >= p1_card && @player2.size >= p2_card
      p1 = Player.new(@player1.id, @player1.cut(p1_card))
      p2 = Player.new(@player2.id, @player2.cut(p2_card))
      winner = RecursiveCombat.new([p1,p2]).play
      if winner.id == p1.id
        @player1.push(p1_card)
        @player1.push(p2_card)
        return @player1
      else
        @player2.push(p2_card)
        @player2.push(p1_card)
        return @player2
      end
    else
      if p1_card > p2_card
        @player1.push(p1_card)
        @player1.push(p2_card)
        return @player1
      else
        @player2.push(p2_card)
        @player2.push(p1_card)
        return @player2
      end
    end
  end
end

players = []
File.read('input_lg.txt').split("\n\n").each do |line|
  data = line.match(/^(?<player>Player \d+):\s+(?<cards>[\d\s]+)$/)
  players << Player.new(data[:player],data[:cards].split("\n"))
end
all_players = Marshal.load(Marshal.dump(players))
# Part 1 (answer is 34566)
game = Game.new(all_players)
game.play
puts "\nPart 1: #{game.winner.id} wins with a score of #{game.winner.score}!"

# Part 2 (answer is 31854)
game = RecursiveCombat.new(players)
game.play
puts game
puts "\nPart 2: #{game.winner.id} wins with a score of #{game.winner.score}!"
