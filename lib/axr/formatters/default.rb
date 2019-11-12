# frozen_string_literal: true

require 'colorized_string'
require_relative 'base'

# TODO: test output format
module AxR
  module Formatters
    class Default < Base
      DOT = '.'
      STAR = '*'

      def single_file(scanner, _file_path)
        if scanner.warnings.any?
          STDOUT.print ColorizedString[STAR].colorize(:yellow)
        else
          STDOUT.print ColorizedString[DOT].colorize(:green)
        end
      end

      def summary(scanned_files, files_with_warnings)
        STDOUT.puts
        STDOUT.puts

        issues_amount = 0

        files_with_warnings.each_pair do |file_path, warnings|
          warnings.each do |warning|
            issues_amount += 1
            msg = "#{file_path}:#{warning.loc_num} # => #{warning.message}"
            STDOUT.puts ColorizedString[msg].colorize(:yellow)
          end
        end

        STDOUT.puts
        STDOUT.puts
        STDOUT.puts("#{scanned_files.size} files scanned. #{issues_amount} issues detected")
      end
    end
  end
end
