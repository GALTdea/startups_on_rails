import { Controller } from "@hotwired/stimulus"

// Navbar controller for handling mobile menu toggle
export default class extends Controller {
    static targets = ["menu", "openIcon", "closeIcon"]

    connect() {
        // Close menu when clicking outside
        document.addEventListener('click', this.handleOutsideClick.bind(this))

        // Close menu when ESC key is pressed
        document.addEventListener('keydown', this.handleKeyDown.bind(this))
    }

    disconnect() {
        document.removeEventListener('click', this.handleOutsideClick.bind(this))
        document.removeEventListener('keydown', this.handleKeyDown.bind(this))
    }

    toggleMenu() {
        this.menuTarget.classList.toggle('hidden')
        this.openIconTarget.classList.toggle('hidden')
        this.closeIconTarget.classList.toggle('hidden')
    }

    closeMenu() {
        if (!this.menuTarget.classList.contains('hidden')) {
            this.menuTarget.classList.add('hidden')
            this.openIconTarget.classList.remove('hidden')
            this.closeIconTarget.classList.add('hidden')
        }
    }

    handleOutsideClick(event) {
        // Only process if menu is open
        if (this.menuTarget.classList.contains('hidden')) return

        // Check if click is outside the navbar
        if (!this.element.contains(event.target)) {
            this.closeMenu()
        }
    }

    handleKeyDown(event) {
        // Close menu when ESC key is pressed
        if (event.key === 'Escape') {
            this.closeMenu()
        }
    }
} 