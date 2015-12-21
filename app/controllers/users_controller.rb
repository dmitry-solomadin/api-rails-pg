class UsersController < ApplicationController
  before_action :load_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render_errors_json(messages: @user.errors.messages, status: :unprocessable_entity)
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render_errors_json(messages: @user.errors.messages, status: :unprocessable_entity)
    end
  end

  def destroy
    if @user.destroy
      head :ok
    else
      render_errors_json(messages: 'User cannot be deleted', status: :unprocessable_entity)
    end
  end

private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
