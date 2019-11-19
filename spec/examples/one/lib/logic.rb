# frozen_string_literal: true

module Logic
  class Runner
    def call
      Repo::User.first
      Api::Controller.new.call
      Repo::User.last
      InvalidApiPath # should be not detected as Api
    end
  end
end
