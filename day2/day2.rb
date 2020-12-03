# https://adventofcode.com/2020/day/2

num_valid = 0

# part 1
def letter_freq()
  File.readlines('input2.txt').each do |line|
    range, letter, pw = line.split()
    range = range.split("-").map(&:to_i)
    letter = letter.delete_suffix(':')
    freq = pw.count(letter)
    puts "#{freq} between #{range.first} and #{range.last}"
    if (freq.between?(range.first,range.last))
      num_valid+=1
    end
  end
  puts "You have #{num_valid} valid passwords out of #{total_pw}"
end

# part 2
File.readlines('input2.txt').each do |line|
  range, letter, pw = line.split()
  range = range.split("-").map(&:to_i)
  letter = letter.delete_suffix(':')

  if ((pw[range.first-1] == letter) ^ (pw[range.last-1] == letter) )
    num_valid+=1
  end
end


puts "You have #{num_valid} valid passwords"
