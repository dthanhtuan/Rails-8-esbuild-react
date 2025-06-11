class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"

  enum :status, { draft: 0, published: 1, archived: 2 }, default: :draft

  # Custom validation to check if a post can be published
  validate :can_be_published, if: -> { status == "published" }

  # Callback to archive posts after 30 days
  after_save :auto_archive, if: -> { saved_change_to_status? && status == "published" }

  private

  def can_be_published
    errors.add(:base, "Title and content must be present to publish") if title.blank? || content.blank?
  end

  def auto_archive
    ArchivePostJob.set(wait: 30.days).perform_later(id)
  end
end
