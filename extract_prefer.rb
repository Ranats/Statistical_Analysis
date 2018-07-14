require "numo/gnuplot"
require "rubyXL"

path = File.expand_path("#{Dir.pwd}/data")
arr = []
files = []
label = []

#loop do
#  print "input filename :"
#  input = gets.chomp
#  if input == "0"
#    break
#  end
#  files << input
#end

files = ["nonPrefer", "on_prefer"]
max = Array.new(2){[]}
mean = Array.new(2){[]}
min = Array.new(2){[]}

files.each_with_index do |f, t|
  1000.times do |i|
    prefer = []
    book = RubyXL::Parser.parse("#{path}/#{f}/fitness#{i}.xlsx")
    sheet = book["#{i}"]
    sheet.each do |row|
      prefer << row[3].value
    end

    max[t] << prefer.max
    mean[t] << prefer.inject(0.0) {|r, i| r += i} / prefer.size
    min[t] << prefer.min

  end
end

book = RubyXL::Workbook.new
files.each_with_index do |f,t|
  if t == 1
    book.add_worksheet(f)
  end
  sheet = book[t]
  sheet.sheet_name = f
  [max[t],mean[t],min[t]].each_with_index do |m,col|
    m.each_with_index do |data,row|
      sheet.add_cell(row,col,data)
    end
  end
end

book.write("data/extract_prefer.xlsx")
