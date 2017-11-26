class Movies::CommentsController < CommentsController
  before_action :set_commentable
  # how to put this before filter into the main comments controller?
  before_action :set_comment, only: :destroy

  private

  def set_commentable
    @commentable = Movie.find(params[:movie_id])
  end
end
