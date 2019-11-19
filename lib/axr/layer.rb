# frozen_string_literal: true

module AxR
  class Layer
    attr_reader :name, :level, :isolated, :familiar_with

    def initialize(name, level, options = {})
      @name          = name
      @level         = level
      @isolated      = options.fetch(:isolated, false)
      @familiar_with = *options.fetch(:familiar_with, [])
    end

    alias isolated? isolated
  end
end
