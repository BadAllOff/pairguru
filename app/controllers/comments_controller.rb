class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:update, :destroy]

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: "Your comment was successfully posted."
    else
      redirect_to @commentable, flash: { alert: @comment.errors.full_messages.to_sentence }
    end
  end

  def destroy
    @comment.destroy if current_user.author_of? @comment
    redirect_to @commentable, notice: "Your comment was deleted."
  end

  def top_commenters
    # It's not the best way to get top commenters
    # but if we cache this query, and execute it once in a day (at low-load time)
    # it can work quite ok.
    # @commenters = User.joins(:comments).where("comments.created_at > ?", Time.zone.now - 7.day).
    #     select("users.*, COUNT(comments.id) as comments_count").
    #     group("comments.user_id").order("comments_count DESC").limit(10)
    # I'll keep it here for a while, to discuss.

    # This one should be better (will save some RAM), but I'm not sure. + Not so secure
    @commenters = User.joins("INNER JOIN comments ON users.id = comments.user_id AND comments.created_at > '#{(Time.zone.now - 7.days).to_s(:db)}'")
      .select("users.*, COUNT(comments.id) as comments_count")
      .group("comments.user_id").order("comments_count DESC").limit(10)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def comment_exists?
    @commentable.comments.exists?(user: current_user)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
