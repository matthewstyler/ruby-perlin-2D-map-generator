# frozen_string_literal: true

require 'map_tile_generator'
require 'map_config'

class Map
  attr_reader :config

  def initialize(map_config: MapConfig.new)
    @config = map_config
  end

  def describe
    tiles.map { |row| row.map(&:to_h) }
  end

  def render
    tiles.each do |row|
      row.each(&:render_to_standard_output)
      puts
    end
  end

  def tiles
    @tiles ||= MapTileGenerator.new(map: self).generate
  end
end
