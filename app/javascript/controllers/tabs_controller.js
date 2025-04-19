import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["tab", "content"]

    connect() {
        // Show the first tab content by default
        this.showTab(this.tabTargets[0])

        // Handle mobile select changes
        const mobileSelect = document.getElementById("section-tabs")
        if (mobileSelect) {
            mobileSelect.addEventListener("change", (event) => {
                const tabId = event.target.value.toLowerCase().replace(/\s+/g, "-")
                this.showTab(this.tabTargets.find(t => t.dataset.tabTarget === tabId))
            })
        }
    }

    switch(event) {
        event.preventDefault()
        const tab = event.currentTarget
        this.showTab(tab)
    }

    showTab(tab) {
        // Update tab buttons
        this.tabTargets.forEach(t => {
            t.classList.remove('border-blue-500', 'text-blue-600')
            t.classList.add('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300')
        })

        tab.classList.remove('border-transparent', 'text-gray-500', 'hover:text-gray-700', 'hover:border-gray-300')
        tab.classList.add('border-blue-500', 'text-blue-600')

        // Update content
        const targetId = tab.dataset.tabTarget
        this.contentTargets.forEach(content => {
            content.classList.add('hidden')
            if (content.id === targetId) {
                content.classList.remove('hidden')
            }
        })

        // Update mobile select if it exists
        const mobileSelect = document.getElementById("section-tabs")
        if (mobileSelect) {
            const optionText = tab.id.split("-").map(word =>
                word.charAt(0).toUpperCase() + word.slice(1)
            ).join(" ")
            mobileSelect.value = optionText
        }
    }
} 