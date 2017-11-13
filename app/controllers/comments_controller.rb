class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:update, :destroy]

  def create
    if comment_exists? then
      redirect_to @commentable, alert: "Delete your old comment first."
    else
      @comment = @commentable.comments.new comment_params
      @comment.user = current_user
      @comment.save
      redirect_to @commentable, notice: "Your comment was successfully posted."
    end
  end

  def destroy
    @comment.destroy if current_user.author_of? @comment
    redirect_to @commentable, notice: "Your comment was deleted."
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def comment_exists?
    @commentable.comments.exists?(user: current_user) ? true : false
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end