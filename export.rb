require 'yaml'

raw = YAML.load_file('quotes.yml')
raw.each do |author|
  # next if i == 0
  # p "--> #{author[0]} #{author[i]}"
  p "---> #{author[0]}"
  author[1].each do |message|
    p ": #{message}"
  end
end
