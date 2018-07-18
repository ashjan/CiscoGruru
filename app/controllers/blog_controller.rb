class BlogController < ApplicationController
  layout 'application'

  def index
    @articles = Article.published.order(created_at: :desc)
  end

  def show
    @article = Article.find params[:id]
    if params[:slug] != @article.slug
      redirect_to @article.url, status: 301 and return
    end
  end
end
