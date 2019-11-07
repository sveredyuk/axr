# frozen_string_literal: true

module AxR
  class Layer
    attr_reader :name, :isolated

    def initialize(name, options = {})
      @name     = name
      @isolated = options.fetch(:isolated, false)
    end
  end
end
