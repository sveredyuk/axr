# frozen_string_literal: true

require 'axr/scanner'
require 'axr/formatters/default'

module AxR
  class Runner
    DOT_RB = '.rb'

    attr_reader :target, :formatter, :exit_on_warnings

    def initialize(target = nil, formatter: AxR::Formatters::Default.new, exit_on_warnings: false)
      @target            = target
      @formatter         = formatter
      @exit_on_warnings = exit_on_warnings
    end

    alias exit_on_warnings? exit_on_warnings

    def invoke
      files_with_warnings = files_to_scan.each_with_object({}) do |file_path, issues|
        scan_result       = AxR::Scanner.new(source: File.open(file_path)).scan
        issues[file_path] = scan_result.warnings if scan_result.warnings.any?

        formatter.single_file(scan_result, file_path)
      end

      formatter.summary(files_to_scan, files_with_warnings)

      exit 1 if exit_on_warnings? && files_with_warnings.any?

      files_with_warnings
    end

    def files_to_scan
      @files_to_scan ||= scan_single_file? ? [target] : Dir.glob("#{target_dir}**/*#{DOT_RB}")
    end

    private

    def scan_single_file?
      return false unless target
      return false unless target.end_with?(DOT_RB)

      target
    end

    def target_dir
      return unless target

      "#{target}/"
    end
  end
end
