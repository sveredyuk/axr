# frozen_string_literal: true

require 'thor'

module AxR
  class CLI < Thor
    desc 'check PATH', 'Start AxR runner'

    option :format # TODO: Add formats

    def check(pattern = nil)
      AxR::Runner.new(pattern).invoke
    end
  end
end
