# frozen_string_literal: true

require 'tty/option'
require 'map'
require 'map_config'
module CLI
  class Command
    include TTY::Option

    usage do
      program 'ruby-perlin-2D-map-generator'

      no_command

      desc 'Generate a seeded customizable procedurally generated 2D map with optional roads. Rendered in the console ' \
           ' using ansi colours, or described as a 2D array of hashes with each tiles information.'

      example 'Render with defaults',
              '  $ ruby-perlin-2D-map-generator render'

      example 'Render with options',
              '  $ ruby-perlin-2D-map-generator render --elevation=-40 --moisture=25 --hs=1'

      example 'Render with roads',
              '  $ ruby-perlin-2D-map-generator render --roads=2'

      example 'Describe tile [1, 1]',
              '  $ ruby-perlin-2D-map-generator describe coordinates=1,1'
    end

    argument :command do
      name '(describe | render)'
      arity one
      permit %w[describe render]
      desc 'command to run: render prints the map to standard output using ansi colors. ' \
           'describe prints each tiles bionome information in the map, can be combined with ' \
           'the coordinates keyword to print a specific tile.'
    end

    keyword :coordinates do
      arity one
      convert :int_list
      validate ->(v) { v >= 0 }
      desc 'Used with the describe command, only returns the given coordinate tile details'
    end

    option :roads_to_make do
      arity one
      long "--roads_to_make ints"
      convert :int_list
      validate ->(v) { v >= 0 }
      desc 'Attempt to create a road from a start and end point (4 integers), can be supplied multiple paths'
      default MapConfig::DEFAULT_ROADS_TO_MAKE
    end

    option :height_seed do
      long '--hs int'
      # or
      long '--hs=int'

      desc 'The seed for a terrains height perlin generation'
      convert Integer
      default MapConfig::DEFAULT_HEIGHT_SEED
    end

    option :moist_seed do
      long '--ms int'
      # or
      long '--ms=int'

      desc 'The seed for a terrains moist perlin generation'
      convert Integer
      default MapConfig::DEFAULT_MOIST_SEED
    end

    option :temp_seed do
      long '--ts int'
      # or
      long '--ts=int'

      desc 'The seed for a terrains temperature perlin generation'
      convert Integer
      default MapConfig::DEFAULT_TEMP_SEED
    end

    option :octaves_height do
      long '--oh int'
      long '--oh=int'

      desc 'Octaves for height generation'
      convert Integer
      default MapConfig::DEFAULT_HEIGHT_OCTAVES
    end

    option :octaves_moist do
      long '--om int'
      long '--om=int'

      desc 'Octaves for moist generation'
      convert Integer
      default MapConfig::DEFAULT_MOIST_OCTAVES
    end

    option :octaves_temp do
      long '--ot int'
      long '--ot=int'

      desc 'Octaves for temp generation'
      convert Integer
      default MapConfig::DEFAULT_TEMP_OCTAVES
    end

    option :persistance_moist do
      long '--pm float'
      long '--pm=float'

      desc 'Persistance for moist generation'
      convert Float
      default MapConfig::DEFAULT_MOIST_PERSISTANCE
    end

    option :persistance_height do
      long '--ph float'
      long '--ph=float'

      desc 'Persistance for height generation'
      convert Float
      default MapConfig::DEFAULT_HEIGHT_PERSISTANCE
    end

    option :persistance_temp do
      long '--pt float'
      long '--pt=float'

      desc 'Persistance for temp generation'
      convert Float
      default MapConfig::DEFAULT_TEMP_PERSISTANCE
    end

    option :width do
      long '--width int'
      long '--width=int'

      desc 'The width of the generated map'
      convert Integer
      default MapConfig::DEFAULT_TILE_COUNT
    end

    option :height do
      long '--height int'
      long '--height=int'

      desc 'The height of the generated map'
      convert Integer
      default MapConfig::DEFAULT_TILE_COUNT
    end

    option :perlin_height_horizontal_frequency do
      long '--fhx float'
      long '--fhx=float'

      desc 'The frequency for height generation across the x-axis'
      convert Float
      default MapConfig::DEFAULT_HEIGHT_X_FREQUENCY
    end

    option :perlin_height_vertical_frequency do
      long '--fhy float'
      long '--fhy=float'

      desc 'The frequency for height generation across the y-axis'
      convert Float
      default MapConfig::DEFAULT_HEIGHT_Y_FREQUENCY
    end

    option :perlin_temp_horizontal_frequency do
      long '--ftx float'
      long '--ftx=float'

      desc 'The frequency for temp generation across the x-axis'
      convert Float
      default MapConfig::DEFAULT_TEMP_X_FREQUENCY
    end

    option :perlin_temp_vertical_frequency do
      long '--fty float'
      long '--fty=float'

      desc 'The frequency for temp generation across the y-axis'
      convert Float
      default MapConfig::DEFAULT_TEMP_Y_FREQUENCY
    end

    option :perlin_moist_horizontal_frequency do
      long '--fmx float'
      long '--fmx=float'

      desc 'The frequency for moist generation across the x-axis'
      convert Float
      default MapConfig::DEFAULT_MOIST_X_FREQUENCY
    end

    option :perlin_moist_vertical_frequency do
      long '--fmy float'
      long '--fmy=float'

      desc 'The frequency for moist generation across the y-axis'
      convert Float
      default MapConfig::DEFAULT_MOIST_Y_FREQUENCY
    end

    option :generate_flora do
      long '--gf bool'
      long '--gf=bool'

      desc 'Generate flora, significantly affects performance'
      convert :bool
      default MapConfig::DEFAULT_GENERATE_FLORA
    end

    option :temp do
      long '--temp float'
      long '--temp=float'

      desc 'Adjust each generated temperature by this percent (0 - 100)'
      convert ->(val) { val.to_f / 100.0 }
      validate ->(val) { val >= -1.0 && val <= 1.0 }
      default MapConfig::DEFAULT_TEMP_ADJUSTMENT
    end

    option :elevation do
      long '--elevation float'
      long '--elevation=float'

      desc 'Adjust each generated elevation by this percent (0 - 100)'
      convert ->(val) { val.to_f / 100.0 }
      validate ->(val) { val >= -1.0 && val <= 1.0 }
      default MapConfig::DEFAULT_HEIGHT_ADJUSTMENT
    end

    option :moisture do
      long '--moisture float'
      long '--moisture=float'

      desc 'Adjust each generated moisture by this percent (0 - 100)'
      convert ->(val) { val.to_f / 100.0 }
      validate ->(val) { val >= -1.0 && val <= 1.0 }
      default MapConfig::DEFAULT_MOIST_ADJUSTMENT
    end

    option :roads do
      long '--roads int'
      long '--roads=int'

      desc 'Add this many roads through the map, starting and ending at edges'
      convert Integer
      validate ->(val) { val >= 0 }
      default MapConfig::DEFAULT_NUM_OF_ROADS
    end

    option :road_seed do
      long '--rs int'
      long '--rs=int'

      desc 'The seed for generating roads'
      convert Integer
      default MapConfig::DEFAULT_ROAD_SEED
    end

    option :road_exclude_water_path do
      long '--road_exclude_water_path bool'
      long '--road_exclude_water_path=bool'

      desc 'Controls if roads will run through water'
      convert :bool
      default MapConfig::DEFAULT_ROAD_EXCLUDE_WATER_PATH
    end

    option :road_exclude_mountain_path do
      long '--road_exclude_mountain_path bool'
      long '--road_exclude_mountain_path=bool'

      desc 'Controls if roads will run through high mountains'
      convert :bool
      default MapConfig::DEFAULT_ROAD_EXCLUDE_MOUNTAIN_PATH
    end

    option :road_exclude_flora_path do
      long '--road_exclude_flora_path bool'
      long '--road_exclude_flora_path=bool'

      desc 'Controls if roads will run tiles containing flora'
      convert :bool
      default MapConfig::DEFAULT_ROAD_EXCLUDE_FLORA_PATH
    end

    flag :help do
      short '-h'
      long '--help'
      desc 'Print usage'
    end

    def run
      if params[:help]
        print help
      elsif params.errors.any?
        puts params.errors.summary
      else
        execute_command
        # pp params.to_h
      end
    end

    private

    def execute_command
      map = Map.new(map_config: MapConfig.new(
        width: params[:width],
        height: params[:height],
        perlin_height_config: perlin_height_config,
        perlin_moist_config: perlin_moist_config,
        perlin_temp_config: perlin_temp_config,
        generate_flora: params[:generate_flora],
        road_config: MapConfig::RoadConfig.new(*params.to_h.slice(:road_seed, :roads, :road_exclude_water_path, :road_exclude_mountain_path, :road_exclude_flora_path, :roads_to_make).values)
      ))
      case params[:command]
      when 'render' then map.render
      when 'describe' then puts(!params[:coordinates].nil? ? map[params[:coordinates][0], params[:coordinates][1]].to_h : map.describe)
      end
    end

    def perlin_moist_config
      MapConfig::PerlinConfig.new(*params.to_h.slice(:width, :height, :moist_seed, :octaves_moist,
                                                     :perlin_moist_horizontal_frequency, :perlin_moist_vertical_frequency, :persistance_moist, :moisture).values)
    end

    def perlin_height_config
      MapConfig::PerlinConfig.new(*params.to_h.slice(:width, :height, :height_seed, :octaves_height,
                                                     :perlin_height_horizontal_frequency, :perlin_height_vertical_frequency, :persistance_height, :elevation).values)
    end

    def perlin_temp_config
      MapConfig::PerlinConfig.new(*params.to_h.slice(:width, :height, :temp_seed, :octaves_temp,
                                                     :perlin_temp_horizontal_frequency, :perlin_temp_vertical_frequency, :persistance_temp, :temp).values)
    end
  end
end
