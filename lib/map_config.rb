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
  DEFAULT_ROAD_EXCLUDE_FLORA_PATH    = true
  DEFAULT_ROADS_TO_MAKE              = [].freeze

  PERLIN_CONFIG_OPTIONS = %i[width height noise_seed octaves x_frequency y_frequency persistance adjustment].freeze
  ALL_PERLIN_CONFIGS    = %i[perlin_height_config perlin_moist_config perlin_temp_config].freeze
  ROAD_CONFIG_OPTIONS   = %i[road_seed roads road_exclude_water_path road_exclude_mountain_path road_exclude_flora_path roads_to_make].freeze

  PerlinConfig = Struct.new(*PERLIN_CONFIG_OPTIONS)
  AllPerlinConfigs = Struct.new(*ALL_PERLIN_CONFIGS)
  RoadConfig = Struct.new(*ROAD_CONFIG_OPTIONS)

  attr_reader :generate_flora, :perlin_height_config, :perlin_moist_config, :perlin_temp_config, :width, :height, :road_config

  def initialize(all_perlin_configs: default_perlin_configs, width: DEFAULT_TILE_COUNT,
                 height: DEFAULT_TILE_COUNT, generate_flora: DEFAULT_GENERATE_FLORA, road_config: default_road_config)
    validate(all_perlin_configs)
    @generate_flora = generate_flora
    @perlin_height_config = all_perlin_configs.perlin_height_config
    @perlin_moist_config = all_perlin_configs.perlin_moist_config
    @perlin_temp_config = all_perlin_configs.perlin_temp_config
    @width = width
    @height = height
    @road_config = road_config
  end

  private

  def validate(all_perlin_configs)
    unless all_perlin_configs.perlin_height_config.is_a?(PerlinConfig) && all_perlin_configs.perlin_moist_config.is_a?(PerlinConfig) && all_perlin_configs.perlin_temp_config.is_a?(PerlinConfig)
      raise ArgumentError
    end
  end

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
    RoadConfig.new(DEFAULT_ROAD_SEED, DEFAULT_NUM_OF_ROADS, DEFAULT_ROAD_EXCLUDE_WATER_PATH, DEFAULT_ROAD_EXCLUDE_MOUNTAIN_PATH, DEFAULT_ROAD_EXCLUDE_FLORA_PATH, DEFAULT_ROADS_TO_MAKE)
  end

  def default_perlin_configs
    AllPerlinConfigs.new(default_perlin_height_config, default_perlin_moist_config, default_perlin_temp_config)
  end
end
