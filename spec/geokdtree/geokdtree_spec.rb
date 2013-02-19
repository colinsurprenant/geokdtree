require 'rspec'
require 'geokdtree'

describe Geokdtree::Tree do

  before do
    @points = {
      :top_left => [-1, -1],
      :mid_upper_left => [-0.5, -0.5],
      :top_right => [1, -1],
      :mid_upper_right => [0.5, -0.5],
      :center => [0, 0],
      :mid_lower_left => [-0.5, 0.5],
      :bottom_left => [-1, 1],
      :mid_lower_right => [0.5, 0.5],
      :bottom_right => [1, 1],
    }

    @places = {
      :seattle => [47.6, -122.3],
      :portland => [45.5, -122.8], 
      :new_york => [40.7, -74.0],
      :los_angeles => [34.1, -118.2],
      :montreal => [45.50, -73.55],
    }
    @insert_places = [:seattle, :portland, :new_york]
  end

  it "should initialize" do
    tree = Geokdtree::Tree.new(2)
    tree.should_not be_nil
  end

  it "should find neighbors in a 2D tree without data" do
    # this spec inspired by https://github.com/sdeming/ffi-kdtree/blob/master/spec/find_nearest_spec.rb
    tree = Geokdtree::Tree.new(2)
    @points.each{|k, p| tree.insert(p)}

    result = tree.nearest([0, 0])
    result.point.should == [0, 0]
    result.data.should be_nil

    result = tree.nearest([0.3, 0.3])
    result.point.should == [0.5, 0.5]
    result.data.should be_nil

    result = tree.nearest([-0.3, -0.3])
    result.point.should == [-0.5, -0.5]
    result.data.should be_nil

    result = tree.nearest([0.1,0.1])
    result.point.should == [0, 0]
    result.data.should be_nil

    results = tree.nearest_range([0, 0], 2)
    results.size.should == 9 

    results = tree.nearest_range([0, 0], 1)
    results.size.should == 5 # center + mids

    tree.nearest_range([10, 10], 1).should == []
  end

  it "should find neighbors in a 2D tree using data" do
    # this spec inspired by https://github.com/sdeming/ffi-kdtree/blob/master/spec/find_nearest_spec.rb
    tree = Geokdtree::Tree.new(2)

    @points.each{|k, p| tree.insert(p, k)}

    result = tree.nearest([0, 0])
    result.point.should == [0, 0]
    result.data.should == :center

    result = tree.nearest([0.3, 0.3])
    result.point.should == [0.5, 0.5]
    result.data.should == :mid_lower_right

    result = tree.nearest([-0.3, -0.3])
    result.point.should == [-0.5, -0.5]
    result.data.should == :mid_upper_left

    result = tree.nearest([0.1,0.1])
    result.point.should == [0, 0]
    result.data.should == :center

    results = tree.nearest_range([0, 0], 2)
    results.size.should == 9
    results.map(&:data).sort.should == @points.to_a.map(&:first).sort

    results = tree.nearest_range([0, 0], 1)
    results.map(&:data).sort.should == [:mid_upper_left, :mid_upper_right, :center, :mid_lower_left, :mid_lower_right].sort

    results = tree.nearest_range([10, 10], 1).should == []
  end

  it "should not find any neighbor in an empty tree" do
    tree = Geokdtree::Tree.new(2)
    tree.nearest([0, 0]).should be_nil
    tree = Geokdtree::Tree.new(3)
    tree.nearest([0, 0, 0]).should be_nil
   end

  it "should find nearest by latlong" do
    tree = Geokdtree::Tree.new(2)
    @insert_places.each{|p| tree.insert(@places[p], p)}

    tree.nearest(@places[:los_angeles]).data.should == :portland
    tree.nearest(@places[:montreal]).data.should == :new_york
  end

  it "should find nearest geo range by latlong" do
    tree = Geokdtree::Tree.new(2)
    @insert_places.each{|p| tree.insert(@places[p], p)}

    tree.nearest_geo_range(@places[:los_angeles], 0).size.should == 0
    tree.nearest_geo_range(@places[:los_angeles], 800).size.should == 0

    tree.nearest_geo_range(@places[:los_angeles], 900).size.should == 1
    tree.nearest_geo_range(@places[:los_angeles], 900).first.data.should == :portland
    tree.nearest_geo_range(@places[:los_angeles], 900, :mi).size.should == 1
    tree.nearest_geo_range(@places[:los_angeles], 900, :mi).first.data.should == :portland

    tree.nearest_geo_range(@places[:los_angeles], 900, :km).size.should == 0
    tree.nearest_geo_range(@places[:los_angeles], 1448, :km).size.should == 1
    tree.nearest_geo_range(@places[:los_angeles], 1448, :km).first.data.should == :portland

    tree.nearest_geo_range(@places[:los_angeles], 957).size.should == 2
    tree.nearest_geo_range(@places[:los_angeles], 957).map(&:data).sort.should == [:portland, :seattle].sort
    tree.nearest_geo_range(@places[:los_angeles], 957, :mi).size.should == 2
    tree.nearest_geo_range(@places[:los_angeles], 957, :mi).map(&:data).sort.should == [:portland, :seattle].sort
    tree.nearest_geo_range(@places[:los_angeles], 1540, :km).size.should == 2
    tree.nearest_geo_range(@places[:los_angeles], 1540, :km).map(&:data).sort.should == [:portland, :seattle].sort

    tree.nearest_geo_range(@places[:los_angeles], 2500).size.should == 3
    tree.nearest_geo_range(@places[:los_angeles], 2500).map(&:data).sort.should == [:portland, :seattle, :new_york].sort
    tree.nearest_geo_range(@places[:los_angeles], 2500, :mi).size.should == 3
    tree.nearest_geo_range(@places[:los_angeles], 2500, :mi).map(&:data).sort.should == [:portland, :seattle, :new_york].sort
    tree.nearest_geo_range(@places[:los_angeles], 4023, :km).size.should == 3
    tree.nearest_geo_range(@places[:los_angeles], 4023, :km).map(&:data).sort.should == [:portland, :seattle, :new_york].sort

    tree.insert(@places[:los_angeles], :los_angeles)

    tree.nearest_geo_range(@places[:los_angeles], 0).size.should == 1
    tree.nearest_geo_range(@places[:los_angeles], 0).first.data.should == :los_angeles
    tree.nearest_geo_range(@places[:los_angeles], 0, :mi).size.should == 1
    tree.nearest_geo_range(@places[:los_angeles], 0, :mi).first.data.should == :los_angeles
    tree.nearest_geo_range(@places[:los_angeles], 0, :km).size.should == 1
    tree.nearest_geo_range(@places[:los_angeles], 0, :km).first.data.should == :los_angeles

    tree.nearest_geo_range(@places[:montreal], 900).size.should == 1
    tree.nearest_geo_range(@places[:montreal], 900).first.data.should == :new_york
    tree.nearest_geo_range(@places[:montreal], 900, :mi).size.should == 1
    tree.nearest_geo_range(@places[:montreal], 900, :mi).first.data.should == :new_york
    tree.nearest_geo_range(@places[:montreal], 1448, :km).size.should == 1
    tree.nearest_geo_range(@places[:montreal], 1448, :km).first.data.should == :new_york
  end

  it "should find nearest using random points" do
    tree = Geokdtree::Tree.new(2)
    random_points = (0...1000).map{|i| [[rand_coord, rand_coord], i]}
    random_points.each{|p| tree.insert(p.first, p.last)}

    100.times do
      random_point = [rand_coord, rand_coord]

      # tree search
      result = tree.nearest(random_point)
      kd_nearest_point = random_points[result.data].first

      # sort search
      sort_nearest_point = random_points.sort_by{|i| Geokdtree::Tree.distance(i.first, random_point)}.first.first

      Geokdtree::Tree.distance(sort_nearest_point, random_point).should == Geokdtree::Tree.distance(kd_nearest_point, random_point)
    end
  end

  it "should compute geo distance" do
    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:portland]).round(0).should == 824
    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:seattle]).round(0).should == 957
    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:new_york]).round(0).should == 2442
    Geokdtree::Tree.geo_distance(@places[:montreal], @places[:new_york]).round(0).should == 332

    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:portland], :mi).round(0).should == 824
    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:seattle], :mi).round(0).should == 957
    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:new_york], :mi).round(0).should == 2442
    Geokdtree::Tree.geo_distance(@places[:montreal], @places[:new_york],:mi).round(0).should == 332

    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:portland], :km).round(0).should == 1327
    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:seattle], :km).round(0).should == 1540
    Geokdtree::Tree.geo_distance(@places[:los_angeles], @places[:new_york], :km).round(0).should == 3931
    Geokdtree::Tree.geo_distance(@places[:montreal], @places[:new_york], :km).round(0).should == 535
  end

  it "should compute distance" do
    Geokdtree::Tree.distance([-1, 1], [1, 1]).should == 2    
    Geokdtree::Tree.distance([-1, 1], [-1, -1]).should == 2
    Geokdtree::Tree.distance([1, 1], [1, 0]).should == 1
    Geokdtree::Tree.distance([0, 0], [-1, 0]).should == 1
    Geokdtree::Tree.distance([0, 0], [0, -1]).should == 1
    Geokdtree::Tree.distance([-0.5, -0.5], [0.5, -0.5]).should == 1
    Geokdtree::Tree.distance([-0.5, -0.5], [0, -0.5]).should == 0.5
  end

end

def rand_coord
  rand(0) * 10 - 5
end

