import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-form"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.submitOnChange()
  }

  submitOnChange() {
    this.element.querySelectorAll("select").forEach(select => {
      select.addEventListener("change", () => {
        this.element.requestSubmit()
      })
    })
  }

  submit() {
    // Add a small delay to prevent multiple rapid submissions
    if (this.submitTimeout) {
      clearTimeout(this.submitTimeout)
    }

    this.submitTimeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 100)
  }
}
