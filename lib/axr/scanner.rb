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
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def scan
      source.each.with_index do |line, index|
        loc_num = index + 1

        line_detection    = AxR.app.layer_names.detect { |layer| line.include?(layer) }
        line_detection    = check_space_before(line, line_detection)
        line_detection    = nil if context && module_definition?(line, line_detection)
        line_detection    = nil if commented?(line, line_detection)
        context_detection = AxR.app.layer_names.detect { |layer| module_definition?(line, layer) }

        next unless context_detection || line_detection

        detect_context(context_detection, line, loc_num) if context_detection && !context
        detect_dependency(line_detection, line, loc_num)
        detect_warning(line_detection,    line, loc_num) if context && line_detection
      end

      self
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

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

    MODULE = 'module'

    def module_definition?(line, layer)
      line.include?("#{MODULE} #{layer}")
    end

    COMMENT = '#'

    def commented?(line, layer)
      return false if line.empty? || layer.nil?

      line.split(layer).first&.include?(COMMENT)
    end
  end
end
