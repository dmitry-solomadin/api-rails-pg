class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    @comments = Comment.order(id: :desc).all
    render_json @comments
  end

  def show
    render_json @comment
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render_json @comment
    else
      render_errors_json(messages: @comment.errors.messages, status: :unprocessable_entity)
    end
  end

  def update
    if @comment.update(comment_params)
      render_json @comment
    else
      render_errors_json(messages: @comment.errors.messages, status: :unprocessable_entity)
    end
  end

  def destroy
    if @comment.destroy
      head :ok
    else
      render_errors_json(messages: 'Comment cannot be deleted', status: :unprocessable_entity)
    end
  end

private

  def comment_params
    params.require(:comment).permit(:text, :parent_id, :parent_type, :author_id)
  end
end
