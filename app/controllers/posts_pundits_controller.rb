class PostsPunditsController < ApplicationController
  def index
  end
  # NOTE: authorize returns the instance passed to it, so you can chain it like this:
  def show
    @user = authorize User.find(params[:id])
    # NOTE: [:admin, User.find(params[:id])] specifies that the authorization should use a namespaced policy
    # (e.g., Admin::UserPolicy) for the User object found by User.find(params[:id]).
    @user = authorize [ :admin, User.find(params[:id]) ]
  end

  def edit
    @post = Post.find(params[:id])
    authorize @post # Authorize the post using PostPolicy `#edit?`
    # The edit action is authorized by the PostPolicy `#edit?` method
  end

  # NOTE: authorize @post : The actually code would have done something like this:
  # unless PostPolicy.new(current_user, @post).update?
  #   raise Pundit::NotAuthorizedError, "not allowed to PostPolicy#update? this Post"
  # end
  def update
    @post = Post.find(params[:id])
    authorize @post # Authorize the post using PostPolicy `#update?`
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit
    end
  end

  def create
    @publication = find_publication # assume this method returns any model that behaves like a publication
    # @publication.class => Post
    authorize(@publication, policy_class: PublicationPolicy)
    @publication.publish!
    redirect_to @publication
  end

  def publish
    @post = Post.find(params[:id])
    authorize @post, :update? # pass the 2nd argument to the authorize method
    @post.publish!
    redirect_to @post
  end

  def admin_list
    authorize Post # we don't have a particular post to authorize
    # Rest of controller action
  end

  private

  def find_publication
    Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :published)
  end
end
