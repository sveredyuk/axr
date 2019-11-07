# frozen_string_literal: true

require 'bundler/setup'
require 'axr'

require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.filter_run_when_matching :focus

  config.around do |example|
    aggregate_failures do
      example.run
    end
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
