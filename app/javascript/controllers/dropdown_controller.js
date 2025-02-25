import { Controller } from "@hotwired/stimulus"

// Dropdown controller for handling dropdown menus
export default class extends Controller {
    static targets = ["menu"]

    connect() {
        // Close dropdown when clicking outside
        document.addEventListener('click', this.handleOutsideClick.bind(this))

        // Close dropdown when ESC key is pressed
        document.addEventListener('keydown', this.handleKeyDown.bind(this))
    }

    disconnect() {
        document.removeEventListener('click', this.handleOutsideClick.bind(this))
        document.removeEventListener('keydown', this.handleKeyDown.bind(this))
    }

    toggle(event) {
        event.stopPropagation()
        this.menuTarget.classList.toggle('hidden')
    }

    hide() {
        this.menuTarget.classList.add('hidden')
    }

    handleOutsideClick(event) {
        // Only process if dropdown is open
        if (this.menuTarget.classList.contains('hidden')) return

        // Check if click is outside the dropdown
        if (!this.element.contains(event.target)) {
            this.hide()
        }
    }

    handleKeyDown(event) {
        // Close dropdown when ESC key is pressed
        if (event.key === 'Escape') {
            this.hide()
        }
    }
} 