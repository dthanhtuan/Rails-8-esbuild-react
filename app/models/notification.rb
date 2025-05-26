class Notification < ApplicationRecord
  after_create_commit :broadcast_notification

  enum :status, { unread: 0, read: 1, archived: 2 }

  private

  # NOTE: by default, broadcast_append_to to lookup the partial using the Notification._to_partial_path
  # Notification._to_partial_path => "notifications/notification"
  # I added `partial` to make it explicit
  def broadcast_notification
    broadcast_append_to "notifications", target: "notifications", partial: "notifications/notification"
  end
end
