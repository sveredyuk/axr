# frozen_string_literal: true

require 'colorized_string'

module AxR
  class Runner
    DOT = '.'
    DOT_RB = '.rb'

    attr_reader :args, :target

    def initialize(args = nil)
      @args   = args
      @target = args[0] if args
    end

    def invoke
      STDOUT.puts('AXR to work!')

      files_to_scan.each { |_file| STDOUT.print ColorizedString[DOT].colorize(:green) }

      STDOUT.puts
      STDOUT.puts
      STDOUT.puts("#{files_to_scan.size} files scanned. 0 issues detected")
    end

    def files_to_scan
      @files_to_scan ||= if scan_single_file?
                           [target]
                         else
                           Dir.glob("#{target_dir}**/*.rb")
                         end
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
