# frozen_string_literal: true

module Api
  class Controller
    def call
      Logic::Runner.new.call
    end
  end
end
