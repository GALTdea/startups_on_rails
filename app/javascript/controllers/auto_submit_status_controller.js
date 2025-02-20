import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-submit-status"
export default class extends Controller {
  connect() {
  }

  submit(event) {
    event.target.form.requestSubmit()
  }
}
