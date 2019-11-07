# frozen_string_literal: true

require 'axr/app'
require 'axr/runner'
require 'axr/version'

module AxR
  def self.app
    @app ||= App.instance
  end
end
