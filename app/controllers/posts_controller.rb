class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_post, only: [:show, :update, :destroy]

  def index
    @posts = Post.all
    render json: @posts
  end

  def show
    render json: @post
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render_errors_json(messages: @post.errors.messages, status: :unprocessable_entity)
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render_errors_json(messages: @post.errors.messages, status: :unprocessable_entity)
    end
  end

  def destroy
    if @post.destroy
      head :ok
    else
      render_errors_json(messages: 'Post cannot be deleted', status: :unprocessable_entity)
    end
  end

private

  def load_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:header, :body, :author_id)
  end
end
