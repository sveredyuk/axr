# frozen_string_literal: true

require 'thor'

module AxR
  class CLI < Thor
    desc 'check PATH',           'Start AxR runner'
    desc '--load APP_INIT_PATH', 'Specify file to load your ruby application'
    desc '--exit-on-warnings',   'Finish with status code 1 on any warnings'

    option :format # TODO: Add more output formats
    option :load
    option :'exit-on-warnings'

    def check(pattern = nil)
      $LOAD_PATH << Dir.pwd
      require options['load'] if options['load']
      AxR::Runner.new(pattern, exit_on_warnings: !options['exit-on-warnings'].nil?).invoke
    end
  end
end
