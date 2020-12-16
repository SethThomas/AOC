require 'set'

class Day16

  attr_reader :rules, :my_ticket, :nearby_tickets

  def initialize(rules, my_ticket,nearby_tickets)
    @rules = parse_rules(rules)
    @my_ticket = my_ticket.sub("your ticket:\n","").split(",")
    @nearby_tickets = parse_nearby_tickets(nearby_tickets)
  end

  def part1
    invalid_ticket_values = []
    @nearby_tickets.each do |ticket|
      ticket.each do |t_val|
        in_ranges = merged_rules.map{ |range| range.include?(t_val) }
        invalid_ticket_values << t_val unless in_ranges.include?(true)
      end
    end
    invalid_ticket_values.reduce(:+)
  end

  def part2
    ticket_columns = valid_tickets.transpose
    possible_answers = Hash.new { |h, k| h[k] = Set.new }

    # build map of rule name => possible row solution
    ticket_columns.each_with_index do |t_col,index|
      rules.each do |rule_name,ranges|
        result = t_col.map {|num| ranges.first.include?(num) || ranges.last.include?(num)}.reduce(:&)
        possible_answers[rule_name].add(index+1) if result == true
      end
    end

    # frequency of rule => rule name
    possible_answer_freq = possible_answers.map{|k,v| [v.length,k]}.to_h
    final_ordering = Array.new(my_ticket.length)
    for index in 1..possible_answers.length
      rule = possible_answer_freq[index]
      to_delete = possible_answers.delete(rule)
      final_ordering[to_delete.first-1] = rule
      possible_answers.each{|k,v| v.subtract(to_delete)}
    end

    final_ordering.each_with_index.filter_map do |rule,index|
      @my_ticket[index].to_i if rule.start_with?("departure")
    end.reduce(:*)
  end

  # return array of valid tickets
  def valid_tickets
    @nearby_tickets.filter_map do |ticket|
      in_ranges = ticket.map do |val|
        merged_rules.map {|val_range| val_range.include?(val)}.include?(true)
      end
      ticket unless in_ranges.include?(false)
    end
  end

  def merged_rules
    merge_overlapping_ranges(@rules.values.flatten)
  end

  def ranges_overlap?(a,b)
    a.include?(b.begin) || b.include?(a.begin)
  end

  def merge_ranges(a, b)
    [a.begin, b.begin].min..[a.end, b.end].max
  end

  def merge_overlapping_ranges(overlapping_ranges)
    overlapping_ranges.sort_by(&:begin).inject([]) do |ranges, range|
      if !ranges.empty? && ranges_overlap?(ranges.last, range)
        ranges[0...-1] + [merge_ranges(ranges.last, range)]
      else
        ranges + [range]
      end
    end
  end

  # turns rules into map of rule names => array of ranges
  #   e.g. "class: 1-3 or 5-7" into  "class" => [(1..3),(5..7)]
  def parse_rules(rules)
    rules.split("\n").map do |rule|
      rule_name,r1,r2,r3,r4 = rule.match(/^([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)$/i).captures
      [rule_name,[(r1.to_i..r2.to_i),(r3.to_i..r4.to_i)]]
    end.to_h
  end

  # build 2D array of ticket values
  def parse_nearby_tickets(nearby_tickets)
    nearby_tickets.sub("nearby tickets:\n","").split("\n").map do |ticket|
      ticket.split(",").map(&:to_i)
    end
  end

end

rules, my_ticket, tickets = File.read("input_lg.txt").split("\n\n")
d16 = Day16.new(rules,my_ticket,tickets)

puts "Answer to part 1: #{d16.part1}"
puts "Answer to part 2: #{d16.part2}"
