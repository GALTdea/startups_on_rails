import { Controller } from "@hotwired/stimulus"

// Simplified Navbar controller for handling mobile menu toggle
export default class extends Controller {
    static targets = ["menu", "openIcon", "closeIcon"]

    connect() {
        console.log("Navbar controller connected")
    }

    toggleMenu(event) {
        console.log("Toggle menu clicked")
        event.preventDefault()

        const menuEl = this.menuTarget
        const openIconEl = this.openIconTarget
        const closeIconEl = this.closeIconTarget

        console.log("Menu element:", menuEl)
        console.log("Open icon element:", openIconEl)
        console.log("Close icon element:", closeIconEl)

        // Toggle menu visibility
        menuEl.classList.toggle('hidden')

        // Toggle icons
        openIconEl.classList.toggle('hidden')
        closeIconEl.classList.toggle('hidden')
    }
} 