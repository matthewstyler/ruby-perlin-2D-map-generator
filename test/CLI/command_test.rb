# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'stringio'
require 'CLI/command'
require 'ostruct'

class CommandTest < Minitest::Test
  def test_run_help_flag
    command = CLI::Command.new

    output = capture_output { command.parse(['--help']).run }
    assert_includes output, 'Usage: '
  end

  def test_run_command_with_errors
    command = CLI::Command.new

    output = capture_output { command.parse(['--unknown']).run }
    expected = "Errors:\n" \
               "  1) Invalid option '--unknown'\n" \
               "  2) Argument '(describe | render)' must be provided\n"

    assert_equal expected, output
  end

  def test_run_render_command
    tiles = [[mock('Tile1'), mock('Tile2')], [mock('Tile3'), mock('Tile4')]]
    map = Map.new
    map.expects(:tiles).returns(tiles)

    Map.expects(:new).with(anything).returns(map)

    output = capture_output do
      tiles.each_with_index do |row, index|
        row.each_with_index do |tile, tindex|
          tile.expects(:render_to_standard_output).returns(print("#{index}#{tindex}"))
        end
      end
      CLI::Command.new.parse(['render']).run
    end

    assert_equal "00011011\n\n", output
  end

  def test_run_describe_command
    tiles = [[mock('Tile1'), mock('Tile2')]]
    map = Map.new
    map.expects(:tiles).returns(tiles)

    Map.expects(:new).with(anything).returns(map)

    tiles.each do |row|
      row.each { |tile| tile.expects(:to_h).returns('tile_data') }
    end
    output = capture_output { CLI::Command.new.parse(['describe']).run }

    assert_equal "tile_data\ntile_data\n", output
  end

  private

  def capture_output
    output = StringIO.new
    $stdout = output
    yield
    output.string
  ensure
    $stdout = STDOUT
  end
end
