# frozen_string_literal: true

require_relative 'scanner/detection'
require_relative 'scanner/warning'

module AxR
  class Scanner
    attr_reader :source, :context, :dependecies, :warnings

    def initialize(source: [])
      @source      = source
      @dependecies = []
      @warnings    = []
      @context     = nil
    end

    # rubocop:disable Metrics/AbcSize
    def scan
      source.each.with_index do |line, index|
        loc_num = index + 1

        line_detection    = AxR.app.layer_names.detect { |layer| line.include?(layer) }
        line_detection    = check_space_before(line, line_detection)
        context_detection = AxR.app.layer_names.detect { |layer| line.include?("module #{layer}") }

        next unless line_detection || context_detection

        detect_context(context_detection, line, loc_num) if context_detection && !context
        detect_dependency(line_detection, line, loc_num)
        detect_warning(line_detection,    line, loc_num) if context
      end

      self
    end
    # rubocop:enable Metrics/AbcSize

    private

    def detect_context(value, loc, loc_num)
      @context = Detection.new(name: value, loc: cleanup_loc(loc), loc_num: loc_num)
    end

    def detect_dependency(value, loc, loc_num)
      return if context && value == context.name

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

    SPACE = ' '

    def check_space_before(line, line_detection)
      return unless line_detection

      line_detection if line[line.index(line_detection) - 1] == SPACE
    end
  end
end
