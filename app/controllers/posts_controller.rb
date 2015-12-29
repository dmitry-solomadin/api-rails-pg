class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    @posts = Post.all
    render_json @posts
  end

  def show
    render_json @post
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      render_json @post
    else
      render_errors_json(messages: @post.errors.messages, status: :unprocessable_entity)
    end
  end

  def update
    if @post.update(post_params)
      render_json @post
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

  def post_params
    params.require(:data).require(:attributes).permit(:header, :body, :author_id)
  end
end
