GoodData::Model::ProjectBuilder.create("Datathon v.457") do |p|

    p.add_dataset("expenses") do |d|
        d.add_fact("__amount", :title => "Amount", :gd_data_type => "DECIMAL(15, 2)")
        d.add_attribute("city")
        d.add_attribute("__id", :title => 'Id')
        d.add_attribute("year")
        d.add_attribute("description")
        d.add_attribute("type")
        d.add_attribute("id")
    end
end