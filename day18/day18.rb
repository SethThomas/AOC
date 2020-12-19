class EquationCruncher

  OP_PRECEDENT = {"+"=>2,"*"=>1}.freeze

  def initialize
  end

  def part1(equation)
    rpn = parse(equation.split("") - [" "])
    calculate(rpn)
  end

  def part2(equation)
    rpn = parse2(equation.split("") - [" "])
    puts "RPN #{rpn}"
    calculate(rpn)
  end

  def parse2(tokens)
    local_output = []
    local_stack = []
    until tokens.empty?
      token = tokens.shift
      if token == "("
        local_output = parse(tokens) + local_output
      elsif token == ")"
        return local_output+=local_stack
      elsif isOperator?(token)
        # TODO implement operator prescedence
        if local_stack.last && precedent(token) > precedent(local_stack.last)

        end
        local_stack.push(token)
      else
        local_output.unshift(token)
      end
    end
    local_output += local_stack
  end

  def parse(tokens)
    local_output = []
    local_stack = []
    until tokens.empty?
      token = tokens.shift
      if token == "("
        local_output = parse(tokens) + local_output
      elsif token == ")"
        return local_output+=local_stack
      elsif isOperator?(token)
        local_stack.push(token)
      else
        local_output.unshift(token)
      end
    end
    local_output += local_stack
  end

  def calculate(q)
    tmp_stack = []
    until q.empty?
      token = q.shift
      if isOperator?(token)
        left,right = tmp_stack.pop(2).map(&:to_i)
        tmp_stack<< left.send(token.to_sym,right)
      else
        tmp_stack<< token
      end
    end
    tmp_stack.first
  end

  def isOperator?(op)
    OP_PRECEDENT.keys.include?(op)
  end

  def precedent(op)
    OP_PRECEDENT[op]
  end

end

input = File.read("input.txt").split("\n")
eq = EquationCruncher.new()
puts input.map { |equation| eq.part1(equation) }.reduce(:+)
