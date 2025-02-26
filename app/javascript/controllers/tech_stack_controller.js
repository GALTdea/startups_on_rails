import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["search", "technology", "category"]

    connect() {
        console.log("Tech Stack controller connected")
    }

    filterTechnologies() {
        const searchTerm = this.searchTarget.value.toLowerCase().trim()

        if (searchTerm === '') {
            // Show all technologies and categories
            this.technologyTargets.forEach(tech => {
                tech.classList.remove('hidden')
            })

            this.categoryTargets.forEach(category => {
                category.classList.remove('hidden')
            })

            return
        }

        // Filter technologies
        this.technologyTargets.forEach(tech => {
            const techName = tech.dataset.name
            if (techName.includes(searchTerm)) {
                tech.classList.remove('hidden')
            } else {
                tech.classList.add('hidden')
            }
        })

        // Hide empty categories
        this.categoryTargets.forEach(category => {
            const visibleTechs = Array.from(category.querySelectorAll('[data-tech-stack-target="technology"]'))
                .filter(tech => !tech.classList.contains('hidden'))

            if (visibleTechs.length === 0) {
                category.classList.add('hidden')
            } else {
                category.classList.remove('hidden')
            }
        })
    }
} 