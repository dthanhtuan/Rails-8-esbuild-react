class NotificationsController < ApplicationController
  before_action :set_notification, only: [ :mark_as_read ]

  def mark_as_read
    @notification.update(status: :read)
    head :no_content
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
