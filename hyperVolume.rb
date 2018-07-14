require "rubyXL"

$path = File.expand_path("#{Dir.pwd}/data/nonPrefer")

# minimize
reference_point = Array.new(3,0)

hyperVolume = []
fitness = []

min = [100,100,100]
reference_point = [100,100,100]

1000.times do |i|
  book = RubyXL::Parser.parse("#{$path}/fitness#{i}.xlsx")
  sheet = book["#{i}"]
  
  fit = []
  sheet.each do |row|
    f = []
    3.times do |idx|
      f << row[idx].value
      if min[idx] > row[idx].value
        min[idx] = row[idx].value
      end
    end
    fit << f
  end
  fitness << fit

  reference_point = [[fit.min_by{|f| f[0]}[0],reference_point[0]].min, [fit.min_by{|f| f[1]}[1],reference_point[1]].min, [fit.min_by{|f| f[2]}[2],reference_point[2]].min]
end

#p reference_point
#p min

fitness.each do |trials|
  # 1試行
  hyper = 0
  trials.each do |fit|
    volume = 1
    fit.each_with_index do |f,i|
      volume *= f - min[i]
    end
    hyper += volume
  end
  hyperVolume << hyper / trials.size
end

#p hyperVolume

book = RubyXL::Workbook.new
sheet = book[0]
sheet.sheet_name = "hyperVolume"
hyperVolume.each_with_index do |hv,i|
  sheet.add_cell(i,0,hv)
end

book.write("output.xlsx")
