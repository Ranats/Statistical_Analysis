require "numo/gnuplot"
require "rubyXL"

path = File.expand_path("#{Dir.pwd}/data")

#loop do
#  print "input filename :"
#  input = gets.chomp
#  if input == "0"
#    break
#  end
#  files << input
#end

files = "extract_prefer.xlsx"
max = Array.new(2){[]}
mean = Array.new(2){[]}
min = Array.new(2){[]}

book = RubyXL::Parser.parse("#{path}/#{files}")
2.times do |i|
  sheet = book[i]
  sheet.each do |row|
    [max[i],mean[i],min[i]].each_with_index do |m, col|
      m << row[col].value
    end
  end
end

p max[0]

Numo.gnuplot do
#  arr.each_with_index do |dta,i|
    set xtics: '("nonPrefer" 0, "prefer" 1)'
#set xtics:"font 'Arial,20'"
    set ylabel: "Average number of prefer tones"
    unset "key"
    set style: "fill solid 0.4 border -1"
    plot [min[0], u: "(0):1", w: :boxplot, lw: 5],
         [min[1], u: "(1):1", w: :boxplot, lw: 5]
#         [mean[1], u: "(1):1", w: :boxplot, lw: 5]
#         [mean[1], u: "(3):1", w: :boxplot, lw: 5],
#         [min[0], u: "(2):1", w: :boxplot, lw: 5]
#         [min[1], u: "(5):1", w: :boxplot, lw: 5]

#  end
end

gets