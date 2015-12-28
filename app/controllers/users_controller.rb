class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    render_json @user
  end

end
