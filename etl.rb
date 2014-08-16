require 'json'
require 'pry'
require 'csv'
require 'active_support/all'

def parse_city(city_name)
  graph_filename = city_name + '_graph.json'
  fail "Graph file has to exist" unless File.exist?(graph_filename)

  data_filename = city_name + '_data.json'
  fail "Data file has to exist" unless File.exist?(data_filename)

  graph = JSON.parse(File.read(graph_filename))
  data = JSON.parse(File.read(data_filename))

  # Clean data
  ds_lookup = graph['data_sets']
  node_lookup = graph["nodes"]

  raw_data = data['amounts']['expenses']
  cleaned_data = []
  raw_data.each_pair {|k, v| v.each_pair {|id, amount| cleaned_data << {'__amount' => amount, '__id' => node_lookup[k]['name']}.merge(ds_lookup[id], )}}
  cleaned_data
end

cities = Dir.glob('*graph.json').map {|x| x.match(/(.*)_graph\.json/)[1]}
headers = ["city", "__amount", "__id", "year", "description", "type", "id"]
CSV.open('output.csv', 'w') do |csv|
  csv << headers
  cities.each do |city|
    # puts city
    d = begin
      parse_city(city)
    rescue
      puts "City #{city} is bad"
      []
    end      
    x = d.map do |row|
      csv << row.merge('city' => city.titleize).values_at(*headers)
    end
  end
end
