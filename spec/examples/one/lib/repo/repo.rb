# frozen_string_literal: true

module Repo
  class User
    def self.after_create
      Logic::Something.execute
    end
  end
end
