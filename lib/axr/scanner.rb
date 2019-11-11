# frozen_string_literal: true

require_relative 'scanner/detection'
require_relative 'scanner/warning'

module AxR
  class Scanner
    attr_reader :file_path, :context, :dependecies, :warnings

    def initialize(file_path:)
      @file_path   = file_path
      @dependecies = []
      @warnings    = []
      @context     = nil
    end

    def scan
      File.open(file_path).each.with_index do |line, index|
        loc_num = index + 1
        line_detection = AxR.app.layer_names.detect { |layer| line.include?(layer) }

        next unless line_detection

        detect_context(line_detection,    line, loc_num) unless context
        detect_dependency(line_detection, line, loc_num)
        detect_warning(line_detection,    line, loc_num)
      end

      self
    end

    private

    def detect_context(value, loc, loc_num)
      @context = Detection.new(name: value, loc: cleanup_loc(loc), loc_num: loc_num)
    end

    def detect_dependency(value, loc, loc_num)
      return if value == context.name

      @dependecies << Detection.new(name: value, loc: cleanup_loc(loc), loc_num: loc_num)
    end

    def detect_warning(value, loc, loc_num)
      return if value == context.name
      return if AxR.app.legal?(context.name, value)

      msg = "#{context.name} layer should not be familiar with #{value}"

      @warnings << Warning.new(message: msg, loc: cleanup_loc(loc), loc_num: loc_num)
    end

    def cleanup_loc(loc)
      loc.chomp.strip
    end
  end
end
