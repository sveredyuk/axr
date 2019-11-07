# frozen_string_literal: true

require 'singleton'

require_relative 'layer'

module AxR
  class App
    include Singleton

    LayerConflictError = Class.new(StandardError)

    attr_reader :layers

    def initialize
      @layers = []
    end

    def define(&block)
      instance_eval(&block)
    end

    def layer(layer_name, options = {})
      check_name_conflict!(layer_name)

      layers << AxR::Layer.new(layer_name, options)
    end

    private

    def check_name_conflict!(layer_name)
      return unless layers.map(&:name).include?(layer_name)

      raise LayerConflictError, "Layer #{layer_name} is already defined in the layout"
    end

    def reset
      @layers = []
    end
  end
end
