# frozen_string_literal: true

require 'colorized_string'

# TODO: test output format

module AxR
  module Formatters
    class Base
      def single_file(_scanner, _file_path)
        raise NotImplementedError
      end

      def summary(_warnings)
        raise NotImplementedError
      end
    end
  end
end
