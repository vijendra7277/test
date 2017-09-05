#!/usr/bin/ruby
# Encoding: utf-8

editor = ENV['EDITOR'] != 'none' ? ENV['EDITOR'] : 'vim'
message_file = ARGV[0]

def check_format_rules(line_number, line)
  puts 'line : '+line
  real_line_number = line_number + 1
  return "Error #{real_line_number}: line should be less than 50 characters in length." if line_number == 0 && line.length > 50
  return "Error #{real_line_number}: Message must be separated by : (colon) " if !line.include? ":"
  if ( !(line.match(/DE\d/) || line.match(/US\d/)))
   puts "Line1 does not contains defect id or user story id"
   return "Error #{real_line_number}: Message must be in particular format"
end
end

while true
  commit_msg = []
  errors = []

  File.open(message_file, 'r').each_with_index do |line, line_number|
    commit_msg.push line
    e = check_format_rules line_number, line.strip
    errors.push e if e
  end
  unless errors.empty?
    File.open(message_file, 'w') do |file|
      file.puts "\n# GIT COMMIT MESSAGE FORMAT ERRORS:"
      errors.each { |error| file.puts "#    #{error}" }
      file.puts "\n"
      commit_msg.each { |line| file.puts line }
    end
    puts 'Invalid git commit message format. Valid format is : <defect or userstory number>:<message>  Press n to cancel the commit. [n]'
    choice = $stdin.gets.chomp
    exit 1 if %w(no n).include?(choice.downcase)
    next if `#{editor} #{message_file}`
  end
  break
end
