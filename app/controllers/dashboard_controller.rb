class DashboardController < ApplicationController
  def index; end

  def show
    authorize :dashboard, :show?
  end
end
