module Api
  module V1
    class PostsController < ApplicationController
      def index
        posts = Post.all
        render json: PostBlueprint.render(posts)
      end

      def show
        post = Post.find(params[:id])
        render json: post
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def create
        post = Post.new(post_params)
        if post.save
          render json: post, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        post = Post.find(params[:id])
        if post.update(post_params)
          render json: post
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      def destroy
        post = Post.find(params[:id])
        post.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        head :not_found
      end

      private

      def post_params
        # Permit user_id, title, status, content
        params.require(:post).permit(:user_id, :title, :status, :content)
      end
    end
  end
end
