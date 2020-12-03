# https://adventofcode.com/2020/day/3

def isTree?(x)
  x.eql? "#"
end

def treeCountAt(arr,i)
  isTree?( arr[i % (arr.length-1)] ) ? 1 : 0
end

def sumTrees(arr,right,down,row=0,col=0)
  return 0 if(row >= arr.length)
  treeCountAt(arr[row],col) + sumTrees(arr,right,down,row+down,col+right)
end

input = File.readlines('input2.txt')

#part 1 195
puts sumTrees(input,3,1)

#part 2 3772314000
puts sumTrees(input,1,1)  *
     sumTrees(input,3,1)  *
     sumTrees(input,5,1)  *
     sumTrees(input,7,1)  *
     sumTrees(input,1,2)
