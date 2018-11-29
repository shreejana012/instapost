# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :owner?, only: %i[edit update]
  before_action :owner?, only: %i[edit update destroy]
  def index
    @posts = Post.all.order('created_at DESC')
                 .includes(:user, comments: :user)
                 .paginate(page: params[:page], per_page: 3)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.create(post_params)
    if @post.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    if @post.valid?
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.delete
    redirect_to root_path
  end

  private

  def owner?
    redirect_to root_path if Post.find(params[:id]).user != current_user
  end

  def post_params
    params.require(:post).permit(:user_id, :photo, :description)
  end
end
