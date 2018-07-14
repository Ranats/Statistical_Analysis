require "numo/gnuplot"
require "rubyXL"

path = File.expand_path("#{Dir.pwd}/data")
arr = []

#files = []
#label = []
#
#loop do
#  print "input filename :"
#  input = gets.chomp
#  if input == "0"
#    break
#  end
#  files << input
#end

files = ["nonPrefer.xlsx", "onPrefer.xlsx"]

files.each do |f|
  book = RubyXL::Parser.parse("#{path}/#{f}")
  sheet = book[0]
  data = []
  sheet.each do |row|
    data << row[0].value
  end
  arr << data
#  print "data label:"
#  label << gets.chomp
end

Numo.gnuplot do
#  arr.each_with_index do |dta,i|
  set xtics:'("nonPrefer" 0, "onPrefer" 1)'
 #set xtics:"font 'Arial,20'"
  set ylabel:"HyperVolume"
  unset "key"
  set style:"fill solid 0.4 border -1"
    plot [arr[0], u: "(0):1", w: :boxplot, lw:5],
         [arr[1], u: "(1):1", w: :boxplot, lw:5]
#  end
end


gets
