# Geokdtree v0.2.0

Ruby & JRuby gem with a fast **k-d tree** C implementation using FFI bindings with support for latitude/longitude and **geo distance range search**.

A [k-d tree](https://en.wikipedia.org/wiki/K-d_tree) is a space-partitioning data structure for organizing points in a k-dimensional space and are useful for very **fast range searches** and **nearest neighbor searches**. k-d trees are a special case of binary space partitioning trees.

## Installation

Tested on **OSX 10.8.2** and **Linux 12.10** with
- MRI Ruby 1.9.3 p362, 1.9.3 p385
- JRuby 1.7.2 (1.9.3 p327)

Add this line to your application's Gemfile:
```
    gem 'geokdtree'
```
And then execute:
```
    $ bundle
```
Or install it yourself as:
```
    $ gem install geokdtree
```

## Usage

``` ruby
  # simplest 2d tree
  tree = Geokdtree::Tree.new(2)
  tree.insert([1, 0])
  tree.insert([2, 0])
  tree.insert([3, 0])

  result = tree.nearest([0, 0])
  puts(result.point.inspect) # => [1.0, 0.0]
  puts(result.data.inspect) # => nil

  # simple 2d tree with point payload. 
  # abritary objects can be attached to each inserted point
  tree = Geokdtree::Tree.new(2)
  tree.insert([1, 0], "point 1")
  tree.insert([2, 0], "point 2")
  tree.insert([3, 0], "point 3")

  # single nearest using standard/Euclidean relative distance
  result = tree.nearest([0, 0])
  puts(result.point.inspect) # => [1.0, 0.0]
  puts(result.data.inspect) # => "point 1"

  # nearests within range using standard/Euclidean relative distance
  results = tree.nearest_range([0, 0], 2)
  puts(results.size) # => 2
  puts(results[0].point.inspect) # => [2.0, 0.0]
  puts(results[0].data.inspect) # => "point 2"
  puts(results[1].point.inspect) # => [1.0, 0.0]
  puts(results[1].data.inspect) # => "point 1"

  # 2d tree with lat/lng points
  tree = Geokdtree::Tree.new(2)
  tree.insert([40.7, -74.0], "New York")
  tree.insert([37.77, -122.41], "San Francisco")
  tree.insert([45.50, -73.55], "Montreal")

  # single nearest using standard/Euclidean relative distance
  result = tree.nearest([34.1, -118.2]) # Los Angeles
  puts(result.point.inspect) # => [37.77, -122.41]
  puts(result.data.inspect) # => "San Francisco"


  # nearests within range using miles relative geo distance
  results = tree.nearest_geo_range([47.6, -122.3], 800) # Seattle, within 800 mi
  puts(results.size) # => 1
  puts(results[0].point.inspect) # => [37.77, -122.41]
  puts(results[0].data.inspect) # => "San Francisco"

  # nearests within range using kilometer relative geo distance
  results = tree.nearest_geo_range([42.35, -71.06], 500, :km) # Boston, within 500 km
  puts(results.size) # => 2
  puts(results[0].point.inspect) # => [45.5, -73.55]
  puts(results[0].data.inspect) # => "Montreal"
  puts(results[1].point.inspect) # => [40.7, -74.0]
  puts(results[1].data.inspect) # => "New York"

  # compute standard/Euclidean distance between two points
  d = Geokdtree::Tree.distance([-1, 1], [1, 1])
  puts(d) # => 2

  # compute geo distance between two points (Montreal, Boston)
  d = Geokdtree::Tree.geo_distance([45.5, -73.55], [42.35, -71.06], :km).round(0)
  puts(d.inspect) # => 403
```

## Developement

1. Fort it
2. Install gems `$ bundle install`
3. Compile lib `$ rake compile`
4. Run specs `$ rake spec`
5. Clean compiler generated files `$ rake clean`

## Contributing

1. Fork it
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am 'Add some feature'`
4. Push to the branch `git push origin my-new-feature`
5. Create new Pull Request

## Credits
- [John Tsiombikas](http://nuclear.mutantstargoat.com/) for writing the [original C kdtree](https://code.google.com/p/kdtree/).

## Author
Colin Surprenant, [@colinsurprenant](http://twitter.com/colinsurprenant), [http://github.com/colinsurprenant](http://github.com/colinsurprenant), colin.surprenant@gmail.com

## License
Geokdtree is distributed under the Apache License, Version 2.0. 
