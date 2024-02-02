class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy download_image delete_image]

  def index
    @articles = Article.all
  end

  def show
    # @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    # if @article.save
    #   redirect_to @article
    # else
    #   render :new, status: :unprocessable_entity
    # end
    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    # @article = Article.find(params[:id])
  end

  def update
    # @article = Article.find(params[:id])

    # pp "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", params[:article][:image_ids]
    # if params[:article][:image_ids]
    #   params[:article][:image_ids].each do |image_id|
    #     image = @article.images.find(image_id)
    #     image.purge
    #   end
    #   params[:article].delete :image_ids
    # end

    # if @article.update(article_params)
    #   # flash[:success] = "編集しました"
    #   redirect_to @article
    # else
    #   render :edit, status: :unprocessable_entity
    # end
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def download_image
    # @article = Article.find(params[:id])
    image = @article.images.find(params[:image_id])
    file = image.blob.download

    if send_data(file, disposition: 'attachment',
                 filename: image.blob.filename.to_s,
                 type: image.blob.content_type)
      # head :no_content
    else
      render json: @article.errors, status: :not_found
    end
  end

  def delete_image
    # @article = Article.find(params[:id])
    image = @article.images.find(params[:image_id])
    image.purge

    # redirect_to edit_article_path(@article)
    respond_to do |format|
      format.html { redirect_to edit_article_path(@article), notice: "Image was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def destroy
    # @article = Article.find(params[:id])
    @article.destroy

    # redirect_to root_path, status: :see_other
    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body, :status, images: [])
    end
end
