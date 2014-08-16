require 'csv'
require 'pp'
require 'bigdecimal'
require 'terminal-table'
require 'pry'

module Enumerable
  def mapcat(initial = [], &block)
    reduce(initial) do |a, e|
      block.call(e).each do |x|
        a << x
      end
      a
    end
  end
end

class SimpleLinearRegression
  def initialize(xs, ys)
    @xs, @ys = xs, ys
    if @xs.length != @ys.length
      raise "Unbalanced data. xs need to be same length as ys"
    end
  end
 
  def y_intercept
    mean(@ys) - (slope * mean(@xs))
  end
 
  def slope
    x_mean = mean(@xs)
    y_mean = mean(@ys)
 
    numerator = (0...@xs.length).reduce(0) do |sum, i|
      sum + ((@xs[i] - x_mean) * (@ys[i] - y_mean))
    end
 
    denominator = @xs.reduce(0) do |sum, x|
      sum + ((x - x_mean) ** 2)
    end
 
    (numerator / denominator)
  end
 
  def mean(values)
    total = values.reduce(0) { |sum, x| x + sum }
    Float(total) / Float(values.length)
  end
end

cities_trendlines = {}
CSV.foreach('trendlines.csv', :headers => true, :return_headers => false) do |line|
  cities_trendlines[line['City']] || cities_trendlines[line['City']] = []
  cities_trendlines[line['City']] << [line['Year'], line['Ratio']]
end


mangled_cities = {}
cities_trendlines.each_pair do |k, v|
  xs = v.mapcat {|x| [x[0]]}
  ys = v.mapcat {|x| [x[1]]}
  mangled_cities[k] = []
  mangled_cities[k] << xs
  mangled_cities[k] << ys
end


results = []
mangled_cities.each_pair do |k, v|
  # puts k
  # puts "----"
  lin = SimpleLinearRegression.new(v[0].map {|n| BigDecimal(n)}, v[1].map {|n| BigDecimal(n)})
  # puts lin.slope.to_f
  # puts
  results << [k, lin.slope.to_f]
  # puts lin.y_intercept
end


# binding.pry
t = Terminal::Table.new :rows => results
# .select {|x| x[1] > 0}.select {|x| x[1] > 0.05}
puts(t)