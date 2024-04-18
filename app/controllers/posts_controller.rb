class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def new
    @post= Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "Object successfully created"
      redirect_to posts_url
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:success] = 'Object was successfully deleted.'
      redirect_to posts_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to posts_url
    end
  end

  def update
    @post = Post.find(params[:id])
      if @post.update_attributes(params[:post])
        flash[:success] = "Object was successfully updated"
        redirect_to @post
      else
        flash[:error] = "Something went wrong"
        render 'edit'
      end
  end


  private

  def post_params
    params.require(:post).permit(:title, :body, :author)
  end

end
