class ProjectsController < ApplicationController
  def approve
    @project = Project.find(params[:id])
    if can?(:approve, @project)
      # Perform the approve action
      @project.update(approved: true)
      redirect_to @project, notice: "Project approved successfully."
    else
      redirect_to @project, alert: "You are not authorized to approve this project."
    end
  end
end
