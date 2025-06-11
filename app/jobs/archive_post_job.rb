class ArchivePostJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find_by(id: post_id)
    return if post.nil? || !post.published?

    post.update!(status: :archived)
  end
end
