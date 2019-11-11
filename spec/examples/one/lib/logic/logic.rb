# frozen_string_literal: true

module Logic
  class Runner
    def call
      Repo::User.first
      Api::Controller.new.call
      Repo::User.last
    end
  end
end
