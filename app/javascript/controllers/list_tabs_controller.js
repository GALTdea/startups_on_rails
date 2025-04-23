import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["tab", "content"]

    switch(event) {
        const button = event.currentTarget
        const targetId = button.dataset.tabTarget

        // Update tab styles
        this.tabTargets.forEach(tab => {
            if (tab === button) {
                tab.classList.add("border-amber-500", "text-amber-600")
                tab.classList.remove("border-transparent", "text-gray-500", "hover:text-gray-700", "hover:border-gray-300")
            } else {
                tab.classList.remove("border-amber-500", "text-amber-600")
                tab.classList.add("border-transparent", "text-gray-500", "hover:text-gray-700", "hover:border-gray-300")
            }
        })

        // Update content visibility
        this.contentTargets.forEach(content => {
            if (content.id === targetId) {
                content.classList.remove("hidden")
            } else {
                content.classList.add("hidden")
            }
        })
    }
} 