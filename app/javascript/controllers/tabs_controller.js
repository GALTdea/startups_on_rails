import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["tab", "content"]

    connect() {
        // Set initial active tab
        this.showTab("featured-companies")

        // Handle mobile select changes
        const mobileSelect = document.getElementById("section-tabs")
        if (mobileSelect) {
            mobileSelect.addEventListener("change", (event) => {
                const tabId = event.target.value.toLowerCase().replace(/\s+/g, "-")
                this.showTab(tabId)
            })
        }
    }

    showTab(tabId) {
        // Update tab buttons
        const buttons = this.element.querySelectorAll("[data-tab-target]")
        buttons.forEach(button => {
            const isActive = button.dataset.tabTarget === tabId
            button.classList.toggle("border-blue-500", isActive)
            button.classList.toggle("text-blue-600", isActive)
            button.classList.toggle("border-transparent", !isActive)
            button.classList.toggle("text-gray-500", !isActive)
        })

        // Update tab contents
        const contents = this.element.querySelectorAll(".tab-content")
        contents.forEach(content => {
            content.classList.toggle("hidden", content.id !== tabId)
        })

        // Update mobile select if it exists
        const mobileSelect = document.getElementById("section-tabs")
        if (mobileSelect) {
            const optionText = tabId.split("-").map(word =>
                word.charAt(0).toUpperCase() + word.slice(1)
            ).join(" ")
            mobileSelect.value = optionText
        }
    }

    switchTab(event) {
        event.preventDefault()
        const tabId = event.currentTarget.dataset.tabTarget
        this.showTab(tabId)
    }
} 