class DashboardController < ApplicationController
  def index
    @notifications = Notification.order(created_at: :desc).limit(2)
  end
end
