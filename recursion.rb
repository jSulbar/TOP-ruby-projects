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
$roman_mapping_to_d = {
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
  if n.zero?
    res
  else
    min_base10_numeral = 10 ** (n.digits.length - 1)
    leftmost_digit_amount = n.digits[-1] * min_base10_numeral

    nearest_min = $roman_mapping_to_r.keys.bsearch do |num|
      num <= leftmost_digit_amount
    end
    roman_numeral = [nearest_min, min_base10_numeral].max

    $roman_mapping_to_r[roman_numeral] + dec_to_r(n - roman_numeral, res)
  end
end

def r_to_dec(n, res = 0)
  if n.nil? || n.empty?
    res
  else
    subtractive_form = $roman_mapping_to_d.include?(n[0..1])
    amount = if subtractive_form
               $roman_mapping_to_d[n[0..1]]
             else
               $roman_mapping_to_d[n[0]]
             end
    r_to_dec(subtractive_form ? n[2..] : n[1..], res + amount)
  end
end