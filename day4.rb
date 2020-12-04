require 'active_support/all'
require 'pp'
require 'pry'
require 'set'

INPUT = File.read('day4.input').chomp

passports = INPUT.split(/\n\n/).map { _1.scan(/(\w+):(\S+)/).to_h }

# Part 1

result_1 = passports.count do |pp|
  (%w[byr iyr eyr hgt hcl ecl pid] - pp.keys).empty?
end

puts result_1 # 204

# Part 2

result_2 = passports.count do |pp|
  pp['byr'] =~ /^\d{4}$/ && (1920..2002).cover?($&.to_i) &&
  pp['iyr'] =~ /^\d{4}$/ && (2010..2020).cover?($&.to_i) &&
  pp['eyr'] =~ /^\d{4}$/ && (2020..2030).cover?($&.to_i) &&
  pp['hgt'] =~ /^(\d+)(cm|in)$/ && ($2 == 'cm' ? 150..193 : 59..76).cover?($1.to_i) &&
  pp['hcl'] =~ /^#\h{6}$/ &&
  pp['ecl'] =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/ &&
  pp['pid'] =~ /^\d{9}$/
end

puts result_2 # 179
