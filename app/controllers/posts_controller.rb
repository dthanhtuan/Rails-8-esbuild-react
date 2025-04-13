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

  def update
    @post = Post.find(params[:id])
    # NOTE: OR authorize! will raise an exception CanCan::AccessDenied if the user is not authorized
    can? :update, @post
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
end
