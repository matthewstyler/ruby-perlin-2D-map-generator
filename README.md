# Ruby Perlin 2D Map Generator

[![Gem Version](https://badge.fury.io/rb/ruby-perlin-2D-map-generator.svg)](https://badge.fury.io/rb/ruby-perlin-2D-map-generator)
![CI Status](https://github.com/matthewstyler/ruby-perlin-2D-map-generator/actions/workflows/main.yml/badge.svg)
![CodeQL](https://github.com/matthewstyler/ruby-perlin-2D-map-generator/workflows/CodeQL/badge.svg)
<a href="https://codeclimate.com/github/matthewstyler/ruby-perlin-2D-map-generator/test_coverage"><img src="https://api.codeclimate.com/v1/badges/b99aae29d02b7a8a4cc6/test_coverage" /></a>
[![Downloads](https://img.shields.io/gem/dt/ruby-perlin-2D-map-generator.svg?style=flat)](https://rubygems.org/gems/ruby-perlin-2D-map-generator)

A gem that procedurally generates seeded and customizable 2D map with optional roads using perlin noise.

Include the gem in your project, or use the executable from the command line.

Map can be rendered in console using ansi colors or returned as 2D array of hashes describing each tile and binome. Completely customizable, use the --help option for full usage details.


![2D-maps](https://github.com/matthewstyler/ruby-perlin-2D-map-generator/assets/4560901/43b008e9-c9c7-422a-9abe-cbe6083fd138)


# Installation

### Bundler

```ruby
gem 'ruby-perlin-2D-map-generator'
```

### Manual

```sh
gem install ruby-perlin-2D-map-generator
```

# Customization examples

See Command line Usage for full customization, below are some examples. Alter the temperature, moisture or elevation seeds to alter these maps:

- Plains with random terrain evens: `ruby-perlin-2D-map-generator render`
- Plains with random terrain events and two roads: `ruby-perlin-2D-map-generator render --roads=2`
- Desert (increase temperature, decrease moisture): `ruby-perlin-2D-map-generator render --temp=100 --moisture=-100`
- Mountainous with lakes (increase elevation, increase moisture) `ruby-perlin-2D-map-generator render --elevation=25 --moisture=25`
- Islands (decreaes elevation, increase moisture): `ruby-perlin-2D-map-generator render --elevation=-40 --moisture=25`
- Taiga map (decrease temperature, increase moisture): `ruby-perlin-2D-map-generator render --temp=-60 --moisture=30 `

## Common customization
```bash
--width=int        The width of the generated map (default 128)
--height=int       The height of the generated map (default 128)

--roads=int        Add this many roads through the map,
                     starting and ending at edges 
                         (default 0)

--hs=int           The seed for a terrains height perlin generation
                         (default 10)
--ms=int           The seed for a terrains moist perlin generation
                         (default 300)
--ts=int           The seed for a terrains temperature perlin generation
                         (default 3000)
--rs=int            The seed for generating roads
                         (default 100)

--elevation=float  Adjust each generated elevation by this percent (-100 -
                         100) (default 0.0)
--moisture=float   Adjust each generated moisture by this percent (-100 -
                         100) (default 0.0)
--temp=float       Adjust each generated temperature by this percent (-100
                         - 100) (default 0.0)
```

## Roads and the heuristic
Roads can be generated by providing a positive integer to the `roads=` argument. Roads are randomly seeded to begin
and start at an axis (but not the same axis).

A* pathfinding is used to generate the roads with a heuristic that uses manhattan distance, favours existing roads and similar elevations in adjacent tiles. 

Roads can be configured to include/exclude generating paths thorugh water, mountains and flora.

Tiles containing roads are of type `road`, those without are of type `terrain`. 

The `--roads_to_make` option allows you to specify multiple pairs of coordinates to attempt to build paths, subject to the heuristic and other option constraints. Expects a a single list, but must be sets of 4, example of two roads: `--roads_to_make=0,0,50,50,0,0,75,75`

# Generate without rendering

```irb
irb(main):001:0> map = Map.new
```

Map can then be manipulated via traditional x,y lookup
```irb
map[x, y].to_h
=>
{:x=>0,                                                        
 :y=>1,                                                        
 :height=>0.29251394359649563,                                 
 :moist=>0.29100678755603004,                                  
 :temp=>0.6034041566100443,                                    
 :biome=>{:name=>"deep_valley", :flora_range=>1, :colour=>"\e[48;5;47m"},
 :items=>[]}
```
or the less intuitative multidimensional lookup (reversed axis):

```irb
map.tiles[y][x].to_h
=> 
{:x=>0,                                                        
 :y=>1,                                                        
 :height=>0.29251394359649563,                                 
 :moist=>0.29100678755603004,                                  
 :temp=>0.6034041566100443,                                    
 :biome=>{:name=>"deep_valley", :flora_range=>1, :colour=>"\e[48;5;47m"},
 :items=>[]}
```

or from the command line:

```bash
$ ruby-perlin-2D-map-generator describe coordinates=0,1

{:x=>0,                                                        
 :y=>1,                                                        
 :height=>0.29251394359649563,                                 
 :moist=>0.29100678755603004,                                  
 :temp=>0.6034041566100443,                                    
 :biome=>{:name=>"deep_valley", :flora_range=>1, :colour=>"\e[48;5;47m"},
 :items=>[]}
```

# Full Command line Usage
```bash
$ ruby-perlin-2D-map-generator --help
```
```bash
Usage: ruby-perlin-2D-map-generator [OPTIONS] (DESCRIBE | RENDER)

Generate a seeded customizable procedurally generated 2D map with optional roads.
Rendered in the console  using ansi colours, or described as a 2D array of
hashes with each tiles information.

Arguments:
  (DESCRIBE | RENDER)  command to run: render prints the map to standard
                       output using ansi colors. describe prints each tiles
                       bionome information in the map, can be combined with the
                       coordinates keyword to print a specific tile.
                       (permitted: describe, render)

Keywords:
  COORDINATES=INT_LIST  Used with the describe command, only returns the given
                        coordinate tile details

Options:
      --elevation=float                  Adjust each generated elevation by
                                         this percent (-100 - 100) (default 0.0)
      --fhx=float                        The frequency for height generation
                                         across the x-axis (default 2.5)
      --fhy=float                        The frequency for height generation
                                         across the y-axis (default 2.5)
      --fmx=float                        The frequency for moist generation
                                         across the x-axis (default 2.5)
      --fmy=float                        The frequency for moist generation
                                         across the y-axis (default 2.5)
      --ftx=float                        The frequency for temp generation
                                         across the x-axis (default 2.5)
      --fty=float                        The frequency for temp generation
                                         across the y-axis (default 2.5)
      --gf=bool                          Generate flora, significantly affects
                                         performance
      --height=int                       The height of the generated map
                                         (default 128)
  -h, --help                             Print usage
      --hs=int                           The seed for a terrains height perlin
                                         generation (default 10)
      --moisture=float                   Adjust each generated moisture by
                                         this percent (-100 - 100) (default 0.0)
      --ms=int                           The seed for a terrains moist perlin
                                         generation (default 300)
      --oh=int                           Octaves for height generation
                                         (default 3)
      --om=int                           Octaves for moist generation (default
                                         3)
      --ot=int                           Octaves for temp generation (default
                                         3)
      --ph=float                         Persistance for height generation
                                         (default 1.0)
      --pm=float                         Persistance for moist generation
                                         (default 1.0)
      --pt=float                         Persistance for temp generation
                                         (default 1.0)
      --road_exclude_flora_path=bool     Controls if roads will run tiles
                                         containing flora
      --road_exclude_mountain_path=bool  Controls if roads will run through
                                         high mountains
      --road_exclude_water_path=bool     Controls if roads will run through
                                         water
      --roads=int                        Add this many roads through the map,
                                         starting and ending at edges (default
                                         0)
      --roads_to_make ints               Attempt to create a road from a start
                                         and end point (4 integers), can be
                                         supplied multiple paths 
                                         (default [])
      --rs=int                           The seed for generating roads
                                         (default 100)
      --temp=float                       Adjust each generated temperature by
                                         this percent (-100 - 100) (default 0.0)
      --ts=int                           The seed for a terrains temperature
                                         perlin generation (default 3000)
      --width=int                        The width of the generated map
                                         (default 128)

Examples:
  Render with defaults
    $ ruby-perlin-2D-map-generator render

  Render with options
    $ ruby-perlin-2D-map-generator render --elevation=-40 --moisture=25 --hs=1
  
  Render with roads
    $ ruby-perlin-2D-map-generator render --roads=2

  Describe tile [1, 1]
    $ ruby-perlin-2D-map-generator describe coordinates=1,1
```
