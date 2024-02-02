class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    # redirect_to article_path(@article)
    respond_to do |format|
      format.html { redirect_to article_path(@article) }
      format.json { head :no_content }
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    # redirect_to article_path(@article), status: :see_other
    respond_to do |format|
      format.html { redirect_to article_path(@article), status: :see_other, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body, :status)
    end
end
