# frozen_string_literal: true

require 'axr/scanner'

module AxR
  class Scanner
    class Warning
      attr_reader :message, :loc, :loc_num

      def initialize(message:, loc:, loc_num:)
        @message = message
        @loc     = loc
        @loc_num = loc_num
      end
    end
  end
end
