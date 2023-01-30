require 'csv'
require 'google-apis-civicinfo_v2'
require 'erb'
require 'pry-byebug'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phonenum(num)
  res = num&.gsub(/[^0-9]/, '')
  return res unless res.length > 10 && num[0] != '1' || res.length > 11 || res.length < 10

  "#{num} (Invalid)"
end

def parse_regdate(regdate)
  date = regdate.split[0].split('/').map(&:to_i)
  time = regdate.split[1].split(':').map(&:to_i)

  [
    date[2] + 2000,
    date[0],
    date[1],
    time[0],
    time[1]
  ]
end

def legislators_by_zipcode(civic_info, zip)
  civic_info.representative_info_by_address(
    address: zip,
    levels: 'country',
    roles: %w[legislatorUpperBody legislatorLowerBody]
  ).officials
rescue StandardError
  'You can find your representatives by visiting ' \
  'www.commoncause.org/take-action/find-elected-officials'
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees_full.csv',
  headers: true,
  header_converters: :symbol
)

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

template_letter = File.read('form_letter.html.erb')
erb_template = ERB.new template_letter
registration_hours = Hash.new(0)
registration_days = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  p clean_phonenum(row[:homephone])
  regdate = Time.new(*parse_regdate(row[:regdate]))
  registration_hours[regdate.hour] += 1
  registration_days[regdate.strftime('%A')] += 1

  # zipcode = clean_zipcode(row[:zipcode])
  # legislators = legislators_by_zipcode(civic_info, zipcode)

  # form_letter = erb_template.result(binding)

  # save_thank_you_letter(id, form_letter)
end
puts(
  registration_days.sort_by { |_, v| v }.to_s,
  registration_hours.sort_by { |_, v| v }.to_s
)
