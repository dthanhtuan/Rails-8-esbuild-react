require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:post) { Post.create!(title: 'Test Title', content: 'Test Content', status: :draft, author: user) }

  describe "GET /index" do
    it "returns a successful response" do
      get posts_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns a successful response" do
      get post_path(post)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "with valid attributes" do
      it "creates a new post" do
        expect {
          post posts_path, params: { post: { title: 'New Title', content: 'New Content', status: :draft, user_id: user.id } }
        }.to change(Post, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not create a new post" do
        expect {
          post posts_path, params: { post: { title: '', content: '', status: :draft, user_id: user.id } }
        }.not_to change(Post, :count)
      end
    end
  end

  describe "PATCH /update" do
    it "updates the post attributes" do
      patch post_path(post), params: { post: { title: 'Updated Title' } }
      expect(post.reload.title).to eq('Updated Title')
    end
  end

  describe "POST /like" do
    it "increments the likes_count of the post" do
      post like_post_path(post)
      expect(post.reload.likes_count).to eq(1)
    end
  end
end
