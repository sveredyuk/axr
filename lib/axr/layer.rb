# frozen_string_literal: true

module AxR
  class Layer
    attr_reader :name, :level, :isolated

    def initialize(name, level, options = {})
      @name     = name
      @level    = level
      @isolated = options.fetch(:isolated, false)
    end
  end
end
