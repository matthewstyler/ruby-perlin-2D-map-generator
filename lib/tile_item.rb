# frozen_string_literal: true

class TileItem
  DEFAULT_RENDER_PRIORITY = 0
  attr_reader :obj, :id, :render_symbol, :colour, :render_priority

  def initialize(obj, render_symbol:, id: object_id, render_priority: DEFAULT_RENDER_PRIORITY)
    @obj = obj
    @id = id
    @render_symbol = render_symbol
    @render_priority = render_priority
  end

  def to_h
    {
      id: id,
      type: obj.class.name.downcase,
      render_symbol: render_symbol,
      render_priority: render_priority
    }
  end
end
