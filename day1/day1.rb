# https://adventofcode.com/2020/day/1

def pairSumTo(arr1, num)
  arr2 = arr1.map { |i| num - i  }
  arr1 & arr2
end

data = File.readlines('input1.txt').collect! &:to_i

# part 1
answer = pairSumTo(data,2020)
puts "#{answer[0]} + #{answer[1]} = #{answer[0]+answer[1]}"
puts "#{answer[0]} * #{answer[1]} = #{answer[0]*answer[1]}"

# # part 2
for i in 0..data.length - 1
  for j in i..data.length - 1
    for k in j..data.length - 1
      if data[i] + data[j] + data[k] == 2020
        product = data[i] * data[j] * data[k]
        puts "#{data[i]} + #{data[j]} + #{data[k]}= 2020"
        puts "#{data[i]} * #{data[j]} * #{data[k]}= #{product}"
        break;
      end
    end
  end
end
