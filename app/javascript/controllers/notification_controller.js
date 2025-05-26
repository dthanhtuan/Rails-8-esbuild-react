import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"

const csrfToken = document.querySelector('meta[name="csrf-token"]').content

export default class extends Controller {
  static values = {notificationId: Number}

  greet() {
    console.log("Hello, Stimulus!", this.element)
  }

  close() {
    // Hide the notification element
    this.element.remove()

    // Send request to backend to mark notification as read
    fetch(`/notifications/${this.notificationIdValue}/mark_as_read`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json"
      }
    })
  }
}
