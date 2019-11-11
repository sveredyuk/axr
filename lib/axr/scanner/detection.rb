# frozen_string_literal: true

require 'axr/scanner'

module AxR
  class Scanner
    class Detection
      attr_reader :name, :loc, :loc_num

      def initialize(name:, loc:, loc_num:)
        @name    = name
        @loc     = loc
        @loc_num = loc_num
      end
    end
  end
end
