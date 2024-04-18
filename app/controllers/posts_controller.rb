class PostsController < ApplicationController

  # Procurar um jeito melhor de authenticar e bloquear áreas
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
  end

  def show
    @post = Post.find(params[:id])
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
    else
      flash[:error] = 'Something went wrong'
    end

    redirect_to posts_url
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
      if @post.update(post_params)
        flash[:success] = "Object was successfully updated"
        redirect_to posts_url
      else
        flash[:error] = "Something went wrong"
        render 'edit'
      end
  end


  private

  def post_params
    params.require(:post).permit(:title, :body, :author)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user
    # Verifique se o usuário atual é o autor do post
    unless current_user.name == @post.author
      redirect_to root_path, alert: 'Você não tem permissão para acessar esta página.'
    end
  end

end
