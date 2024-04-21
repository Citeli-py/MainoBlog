class PostsController < ApplicationController

  # Procurar um jeito melhor de authenticar e bloquear áreas
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :authorize_user_modify, only: [:edit, :update, :destroy]
  before_action :authorize_user, only: [:new]

  def index
    @posts = Post.order(created_at: :desc).paginate(page: params[:page], per_page: 3)

    if !params[:tag_id].nil?
      @posts = @posts.joins(:post_tags).where(post_tags: { tag_id: params[:tag_id] })
    end
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
      flash[:alert] = "Something went wrong"
      render 'new'
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      flash[:success] = 'Object was successfully deleted.'
    else
      flash[:alert] = 'Something went wrong'
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
    params.require(:post).permit(:title, :body, :user_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user
    unless user_signed_in?
      redirect_to root_path, alert: 'Você não tem permissão para acessar esta página.'
    end
  end

  def authorize_user_modify
    # Verifique se o usuário atual é o autor do post
    unless user_signed_in? and current_user.id == @post.user_id
      redirect_to root_path, alert: 'Você não tem permissão para acessar esta página.'
    end
  end

end
