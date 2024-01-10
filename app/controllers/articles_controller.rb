class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    # pp "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", params[:article][:image_ids]
    # if params[:article][:image_ids]
    #   params[:article][:image_ids].each do |image_id|
    #     image = @article.images.find(image_id)
    #     image.purge
    #   end
    #   params[:article].delete :image_ids
    # end

    # # @article.images.attach(params[:images]) if @article.images.blank?
    if @article.update(article_params)
      # flash[:success] = "編集しました"
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def download_image
    @article = Article.find(params[:id])
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
    @article = Article.find(params[:id])
    image = @article.images.find(params[:image_id])
    image.purge
    redirect_to edit_article_path(@article)
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status, images: [])
    end
end
