# frozen_string_literal: true

require 'singleton'

require_relative 'layer'

module AxR
  class App
    include Singleton

    LayerConflictError = Class.new(StandardError)

    attr_reader :layers, :default_options

    def initialize
      @layers = []
    end

    def define(default_options = {}, &block)
      @default_options = default_options
      instance_eval(&block)
    end

    def layer(layer_name, options = {})
      check_name_conflict!(layer_name)

      layers << AxR::Layer.new(layer_name, layers.size, default_options.merge(options))
    end

    def layer_names
      layers.map(&:name).map(&:to_s)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def legal?(context, dependncy)
      ctx = layers.find { |l| l.name.to_s == context.to_s }
      dep = layers.find { |l| l.name.to_s == dependncy.to_s }

      return false unless ctx && dep
      return false if ctx.isolated? && ctx.familiar_with.empty?
      return true  if ctx.familiar_with.map(&:to_s).include?(dependncy.to_s)

      ctx.level < dep.level
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    private

    def check_name_conflict!(layer_name)
      return unless layers.map(&:name).include?(layer_name)

      raise LayerConflictError, "Layer #{layer_name} is already defined in the app"
    end

    # Use only for testing purpose!
    def reset
      @layers = []
    end
  end
end
