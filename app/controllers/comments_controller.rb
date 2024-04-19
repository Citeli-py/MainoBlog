class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    redirect_to root_path
  end

  def destroy
    @post = Post.find(params[:post_id])
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
      params.require(:comment).permit(:author, :body)
    end

end
