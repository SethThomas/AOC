# https://adventofcode.com/2020/day/19

# returns true if string can be built using the given rules
def can_build?(str,rules)
  # base case: no more rules or characters to match
  return str.empty? && rules.empty? if str.empty? || rules.empty?

  # grab the first rule definition
  rule = $the_rules[rules.first]

  # if this rule has a character somewhere
  if rule.include?("a") || rule.include?("b")
    # if there is a match on the first character of the string
    if rule.include?(str[0])
      # recurse on the next character in the string, and the remaining rules
      return can_build?(str[1..-1],rules[1..-1])
    else
      # no match, we can stop going down this path
      return false
    end
  else
    # this rule doesn't have a character, so we need to check all sub rules
    return rule.map{ |sub_rule| can_build?(str,sub_rule + rules[1..-1])}.reduce(:|)
  end
end

rules,messages = File.read("input.txt").split("\n\n")
messages = messages.split("\n")
$the_rules = {}

rules.split("\n").each do |r|
  data = r.match(/(?<rule_num>\d+): (?<rule_set>.+)\Z/)
  if data[:rule_set].include?("\"")
    $the_rules[data[:rule_num]] = data[:rule_set].tr("\"","")
  else
    $the_rules[data[:rule_num]]= data[:rule_set].split(" | ").map{|r| r.split(" ") }
  end
end

puts messages.map {|m| can_build?(m,["0"])}.count(true)
