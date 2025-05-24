class PostsController < ApplicationController
  def like
    @post = Post.find(params[:id])
    if can?(:like, @post)
      # Perform the like action
      @post.increment!(:likes_count)
      redirect_to @post, notice: "You liked this post."
    else
      redirect_to @post, alert: "You are not authorized to like this post."
    end
  end

  def index
    @posts = Post.all
    render :index
  end

  def show
    @post = Post.find(params[:id])
    render :show
  end

  def update
    @post = Post.find(params[:id])
    can? :update, @post
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("post_form", partial: "posts/form", locals: { post: @post }) }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :status, :user_id)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
end
