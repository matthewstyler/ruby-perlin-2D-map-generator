# frozen_string_literal: true

#
# Generates flora for the given tiles
#
class FloraGenerator
  attr_reader :tiles

  def initialize(tiles)
    @tiles = tiles
  end

  def generate(config)
    return unless config.generate_flora

    puts 'generating flora...' if config.verbose
    tiles.each do |row|
      row.each do |tile|
        next unless tile.biome.flora_available

        range_max_value = tiles[(tile.y - tile.biome.flora_range)...(tile.y + tile.biome.flora_range)]&.map do |r|
          r[(tile.x - tile.biome.flora_range)...(tile.x + tile.biome.flora_range)]
        end&.flatten&.map(&:height)&.max
        tile.add_flora if range_max_value == tile.height
      end
    end
  end
end
