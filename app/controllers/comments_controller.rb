# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :owner?, only: :destroy
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params.merge(user_id: current_user.id))
    if @comment.valid?
    else
      flash[:alert] = 'Invalid attributes.'
    end
    redirect_to root_path
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to root_path
  end

  private

  def owner?
    @comment = Comment.find(params[:id])
    redirect_to root_path if @comment.user != current_user
  end

  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end
end
