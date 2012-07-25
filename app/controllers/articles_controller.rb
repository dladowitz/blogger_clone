class ArticlesController < ApplicationController
  before_filter :require_login, :except => [:index, :show]
  
  def index
      
    # @articles = Article.ordered_by(params[:order_by]).limit(params[:limit])
    @articles = Article.only(params[:limit]).ordered_by(params[:order_by])
    
    

  end

  def show
    @article = Article.find(params[:id])
    
    audit @article.inspect
  end

  def new
    @article = Article.new
  end

  def create
    # @article = Article.new(:title => params[:article][:title], :tag_list => params[:article][:tag_list], :body => params[:article][:body])
    @article = Article.new(params[:article])
    @article.word_count =(params[:article][:body].split.length)
    puts "Here are the params you ordered: #{params}"
    warn "This is the object after initialization: #{@article.inspect}"
    
    audit @article.inspect
    # binding.pry
    
    @article.save

    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:id])

    @article.destroy
    
    audit @article.inspect
    
    redirect_to articles_path
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update_attributes(params[:article])
    audit @article.inspect

    flash[:message] = "Article '#{@article.title}' Updated!"

    redirect_to article_path(@article)
  end
end
