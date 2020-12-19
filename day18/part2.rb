class Integer
  def %(operand)
    self + operand
  end

  def **(operand)
    self + operand
  end
end

input = File.read("input.txt").split("\n")
puts input.map {|equation| eval(equation.gsub("+","%"))}.reduce(:+)
puts input.map {|equation| eval(equation.gsub("+","**"))}.reduce(:+)
