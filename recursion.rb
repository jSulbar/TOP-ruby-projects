def factorial(n, cn = nil)
  cn = n if cn.nil?
  if n == 1
    cn
  else
    factorial(n - 1, cn * (n - 1))
    # n * factorial(n - 1) ????
  end
end

def palindrome?(str)
  if str.length == 1 || str.length == 2 && str[0] == str[-1]
    true
  elsif str.downcase[0] == str.downcase[-1]
    palindrome?(str.slice(0).slice(-1))
  else
    false
  end
end

def beer(n)
  if n.zero?
    puts 'no more bottles of piss on the wall'
  else
    puts "#{n} bottles of piss on the wall"
    beer(n - 1)
  end
end

def fibonacci_i(index, prev = 0, current = 1)
  return fibonacci_i(index - 1, current, prev + current) unless index == 1

  current
end

def flatten(arr, res = [])
  arr.each do |el|
    if el.is_a?(Enumerable)
      flatten(el, res)
    else
      res.push(el)
    end
  end
  res
end

$roman_mapping_to_r = {
  1000 => "M",
  900 => "CM",
  500 => "D",
  400 => "CD",
  100 => "C",
  90 => "XC",
  50 => "L",
  40 => "XL",
  10 => "X",
  9 => "IX",
  5 => "V",
  4 => "IV",
  1 => "I"
}
roman_mapping_to_i = {
  "M" => 1000,
  "CM" => 900,
  "D" => 500,
  "CD" => 400,
  "C" => 100,
  "XC" => 90,
  "L" => 50,
  "XL" => 40,
  "X" => 10,
  "IX" => 9,
  "V" => 5,
  "IV" => 4,
  "I" => 1
}

def dec_to_r(n, res = '')
  # infinite recursion lmfao
  max_decimal_place = 10 ** (n.to_s.length - 1)
  first_num = n.to_s[0].to_i
  numeral_amount = first_num / max_decimal_place

  puts "#{max_decimal_place}, #{first_num}, #{numeral_amount}"
  
  # Division is still wrong, i think.
  # I don't think this times loop is the solution if i have to hardcode
  # the ternary operator here when numeral_amount is 0 (aka when it works)
  (numeral_amount >= 1 ? numeral_amount : 1).times do # Base case
    # These if conditions somehow fucked up the algorithm (more)
    #if $roman_mapping_to_r.include?(first_num)
      res += $roman_mapping_to_r[max_decimal_place]
    #else
      # How to make 7 be typed as VII instead of 7 Is.
      # it is doing res += "I" 7 times, then 6... because x / 1 = x
    #end
  end

  if n.zero?
    res # End condition
  else
    dec_to_r(n - max_decimal_place, res) # Continue branch
  end
end

def r_to_dec(n, res)
end

p dec_to_r(1237)
