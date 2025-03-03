import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["dropdown"]

    connect() {
        // Optional: Close on click outside
        document.addEventListener("click", this.closeOnClickOutside.bind(this))

        // Listen for form submissions
        document.addEventListener('turbo:submit-start', this.handleFormSubmit.bind(this))
    }

    disconnect() {
        document.removeEventListener("click", this.closeOnClickOutside.bind(this))
        document.removeEventListener('turbo:submit-start', this.handleFormSubmit.bind(this))
    }

    toggle(event) {
        event.stopPropagation()
        this.dropdownTarget.classList.toggle("hidden")
        this.dropdownTarget.classList.toggle("opacity-0")
        this.dropdownTarget.classList.toggle("scale-95")
    }

    closeOnClickOutside(event) {
        if (!this.element.contains(event.target)) {
            this.dropdownTarget.classList.add("hidden")
            this.dropdownTarget.classList.add("opacity-0")
            this.dropdownTarget.classList.add("scale-95")
        }
    }

    handleFormSubmit(event) {
        // Don't close if it's not our form
        if (!this.element.contains(event.target)) return

        // Close dropdown after form submission
        this.dropdownTarget.classList.add("hidden")
        this.dropdownTarget.classList.add("opacity-0")
        this.dropdownTarget.classList.add("scale-95")
    }
} 