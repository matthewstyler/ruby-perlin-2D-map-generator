# frozen_string_literal: true

class MapConfig
  DEFAULT_TILE_COUNT = 128
  DEFAULT_GENERATE_FLORA = true

  DEFAULT_HEIGHT_SEED = 10
  DEFAULT_HEIGHT_OCTAVES = 3
  DEFAULT_HEIGHT_X_FREQUENCY = 2.5
  DEFAULT_HEIGHT_Y_FREQUENCY = 2.5
  DEFAULT_HEIGHT_PERSISTANCE = 1.0
  DEFAULT_HEIGHT_ADJUSTMENT  = 0.0

  DEFAULT_MOIST_SEED = 300
  DEFAULT_MOIST_OCTAVES = 3
  DEFAULT_MOIST_X_FREQUENCY = 2.5
  DEFAULT_MOIST_Y_FREQUENCY = 2.5
  DEFAULT_MOIST_PERSISTANCE = 1.0
  DEFAULT_MOIST_ADJUSTMENT  = 0.0

  DEFAULT_TEMP_SEED = 3000
  DEFAULT_TEMP_OCTAVES = 3
  DEFAULT_TEMP_PERSISTANCE = 1.0
  DEFAULT_TEMP_Y_FREQUENCY = 2.5
  DEFAULT_TEMP_X_FREQUENCY = 2.5
  DEFAULT_TEMP_ADJUSTMENT  = 0.0

  DEFAULT_ROAD_SEED                  = 100
  DEFAULT_NUM_OF_ROADS               = 0
  DEFAULT_ROAD_EXCLUDE_WATER_PATH    = true
  DEFAULT_ROAD_EXCLUDE_MOUNTAIN_PATH = true

  PERLIN_CONFIG_OPTIONS = %i[width height noise_seed octaves x_frequency y_frequency persistance adjustment].freeze
  ROAD_CONFIG_OPTIONS = %i[road_seed roads road_exclude_water_path road_exclude_mountain_path].freeze

  PerlinConfig = Struct.new(*PERLIN_CONFIG_OPTIONS)
  RoadConfig = Struct.new(*ROAD_CONFIG_OPTIONS)

  attr_reader :generate_flora, :perlin_height_config, :perlin_moist_config, :perlin_temp_config, :width, :height, :road_config

  def initialize(perlin_height_config: default_perlin_height_config, perlin_moist_config: default_perlin_moist_config, perlin_temp_config: default_perlin_temp_config, width: DEFAULT_TILE_COUNT,
                 height: DEFAULT_TILE_COUNT, generate_flora: DEFAULT_GENERATE_FLORA, road_config: default_road_config)
    raise ArgumentError unless perlin_height_config.is_a?(PerlinConfig) && perlin_moist_config.is_a?(PerlinConfig)

    @generate_flora = generate_flora
    @perlin_height_config = perlin_height_config
    @perlin_moist_config = perlin_moist_config
    @perlin_temp_config = perlin_temp_config
    @width = width
    @height = height
    @road_config = road_config
  end

  private

  def default_perlin_height_config
    PerlinConfig.new(DEFAULT_TILE_COUNT, DEFAULT_TILE_COUNT, DEFAULT_HEIGHT_SEED, DEFAULT_HEIGHT_OCTAVES,
                     DEFAULT_HEIGHT_X_FREQUENCY, DEFAULT_HEIGHT_Y_FREQUENCY, DEFAULT_HEIGHT_PERSISTANCE, DEFAULT_HEIGHT_ADJUSTMENT)
  end

  def default_perlin_moist_config
    PerlinConfig.new(DEFAULT_TILE_COUNT, DEFAULT_TILE_COUNT, DEFAULT_MOIST_SEED, DEFAULT_MOIST_OCTAVES,
                     DEFAULT_MOIST_X_FREQUENCY, DEFAULT_MOIST_Y_FREQUENCY, DEFAULT_MOIST_PERSISTANCE, DEFAULT_MOIST_ADJUSTMENT)
  end

  def default_perlin_temp_config
    PerlinConfig.new(DEFAULT_TILE_COUNT, DEFAULT_TILE_COUNT, DEFAULT_TEMP_SEED, DEFAULT_TEMP_OCTAVES,
                     DEFAULT_TEMP_X_FREQUENCY, DEFAULT_TEMP_Y_FREQUENCY, DEFAULT_TEMP_PERSISTANCE, DEFAULT_TEMP_ADJUSTMENT)
  end

  def default_road_config
    RoadConfig.new(DEFAULT_ROAD_SEED, DEFAULT_NUM_OF_ROADS)
  end
end
