class Passport

  attr_reader :errors

  def initialize(args = {})
    @args = args
    @errors = []
  end

  def byrValid?(byr)
    byr.to_i.between?(1920,2002)
  end

  def iyrValid?(iyr)
    iyr.to_i.between?(2010,2020)
  end

  def eyrValid?(eyr)
    eyr.to_i.between?(2020,2030)
  end

  def hgtValid?(hgt)
    if (hgt.end_with?("cm"))
       hgt.chomp("cm").to_i.between?(150,193)
    elsif (hgt.end_with?("in"))
       hgt.chomp("in").to_i.between?(59,76)
    end
  end

  def hclValid?(hcl)
    /^#[0-9a-f]{6}$/.match(hcl)
  end

  def eclValid?(ecl)
    ["amb","blu","brn","gry","grn","hzl","oth"].include?(ecl)
  end

  def pidValid?(pid)
    /^\d{9}$/.match(pid)
  end

  def requiredFieldsPresent?()
    requiredKeys = ["byr","iyr","eyr","hgt","hcl","ecl","pid"]
    # difference should be empty array if all fields present (or no extra fields)
    (requiredKeys - @args.keys).each {|miss| @errors<< "#{miss} not present"}
    @errors.empty?
  end


  # validate fields and populate errors array
  def valid?()
    if( requiredFieldsPresent? )
      # check each condition, saving off error if one exists (ugh...)
      @errors << "byr is not valid #{@args["byr"]}" if !byrValid?(@args["byr"])
      @errors << "iyr is not valid #{@args["iyr"]}" if !iyrValid?(@args["iyr"])
      @errors << "eyr is not valid #{@args["eyr"]}" if !eyrValid?(@args["eyr"])
      @errors << "hgt is not valid #{@args["hgt"]}" if !hgtValid?(@args["hgt"])
      @errors << "hcl is not valid #{@args["hcl"]}" if !hclValid?(@args["hcl"])
      @errors << "ecl is not valid #{@args["ecl"]}" if !eclValid?(@args["ecl"])
      @errors << "pid is not valid #{@args["pid"]}" if !pidValid?(@args["pid"])
    end
    @errors.empty?
  end
end

numValidPassports = 0
passportArgs = {}
File.read("input1.txt").split("\n\n").each do |passportStr|
  tokenHash = passportStr.split(/\s/).map{|token| token.split(":")}.to_h
  p = Passport.new(tokenHash)
  numValidPassports+=1 if p.valid?
  # puts "Invalid #{p.inspect}" if !p.valid?
end

puts "Number of valid passports: #{numValidPassports}"
