# frozen_string_literal: true

require 'thor'

module AxR
  class CLI < Thor
    desc 'check PATH', 'Start AxR runner'

    option :format # TODO: Add formats
    option :load   # TODO: Add formats

    def check(pattern = nil)
      $LOAD_PATH << Dir.pwd
      require options['load'] if options['load']
      AxR::Runner.new(pattern).invoke
    end
  end
end
