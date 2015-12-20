class CommentsController < ApplicationController
  before_action :load_comment, only: [:show, :update, :destroy]

  def index
    @comments = Comment.all
    render json: @comments
  end

  def show
    render json: @comment
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render_errors_json(messages: @comment.errors.messages, status: :unprocessable_entity)
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
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

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text, :parent_id, :parent_type, :author_id)
  end
end
