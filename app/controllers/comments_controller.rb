class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    redirect_to root_path
  end

  def destroy
    @post = Post.find(params[:post_id])
    authorize_user_modify

    @comment = @post.comments.find(params[:id])

    if @comment.destroy
      flash[:success] = 'Object was successfully deleted.'
    else
      flash[:error] = 'Something went wrong'
    end

    redirect_to root_path
  end


  private
    def comment_params
      params.require(:comment).permit(:user_id, :body)
    end

    def authorize_user_modify
      # O dono do post pode deletar comentários anonimos
      unless user_signed_in? and current_user.id == @post.user_id
        redirect_to root_path, alert: 'Você não tem permissão para acessar esta página.'
      end
    end
end
