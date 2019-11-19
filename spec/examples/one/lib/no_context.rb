# frozen_string_literal: true

class AnyController
  def index
    @users = Repo::User.all
  end

  def create
    Logic::CreateUser.call(params)
  end
end
