#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'json'

url = 'http://unicode.org/emoji/charts/full-emoji-list.html'
basename = File.basename(url)

if File.exists?(basename)
  html = open(basename)
else
  html = open(url)
  open(basename, 'w') do |f|
    content = html.read
    f.puts content
    html = content
  end
end

document = Nokogiri::HTML(html) do |config|
  config.options = Nokogiri::XML::ParseOptions::NOBLANKS |
    Nokogiri::XML::ParseOptions::NOERROR |
    Nokogiri::XML::ParseOptions::HUGE
end

emojis = []
document.css('tr:has(td.chars)').each do |tr|
  emojis.push({
    name: tr.css('td.name').text.strip,
    char: tr.css('td.chars').text.strip
  })
end

File.open('emojis.json', 'w') do |f|
  f.puts JSON.generate(emojis)
end
