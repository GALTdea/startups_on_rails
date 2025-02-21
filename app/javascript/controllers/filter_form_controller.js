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
    this.element.requestSubmit()
  }
}
