require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:author).class_name('User').with_foreign_key('user_id') }
  end

  describe 'enums' do
    it 'defines the correct statuses' do
      expect(Post.statuses).to eq({ 'draft' => 0, 'published' => 1, 'archived' => 2 })
    end

    it 'sets the default status to draft' do
      post = Post.new
      expect(post.status).to eq('draft')
    end
  end

  describe 'validations' do
    it 'does not allow publishing without a title and content' do
      post = Post.new(status: 'published', title: nil, content: nil)
      expect(post).not_to be_valid
      expect(post.errors[:base]).to include("Title and content must be present to publish")
    end

    it 'allows publishing with a title and content' do
      post = Post.new(status: 'published', title: 'Valid Title', content: 'Valid Content')
      expect(post).to be_valid
    end
  end

  describe 'callbacks' do
    it 'schedules an archive job after publishing' do
      post = Post.create!(status: 'published', title: 'Title', content: 'Content', author: User.create!(email: 'test@example.com', password: 'password'))
      expect(ArchivePostJob).to have_been_enqueued.with(post.id).at_least(30.days.from_now)
    end
  end
end
