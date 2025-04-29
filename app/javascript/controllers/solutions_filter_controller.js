import { Controller } from "@hotwired/stimulus"

/**
 * Solutions Filter Controller
 *
 * Handles dynamic filtering of solutions based on category types and selections
 */
export default class extends Controller {
    static targets = [
        "categoryGroup",
        "technologyList",
        "techStackContent",
        "techStackToggleText",
        "techStackToggleIcon",
        "categoriesContent",
        "categoriesToggleText",
        "categoriesToggleIcon"
    ]

    connect() {
        this.updateCategoryVisibility()
        this.initTechStackState()
        this.initCategoriesState()
    }

    /**
     * Initialize the tech stack dropdown state
     * Show it if technologies are selected
     */
    initTechStackState() {
        // Check if there are any selected technologies
        const urlParams = new URLSearchParams(window.location.search)
        if (urlParams.has('technology_ids')) {
            this.toggleTechStack()
        }
    }

    /**
     * Initialize the categories dropdown state
     * Show it if categories are selected
     */
    initCategoriesState() {
        // Check if there are any selected categories
        const urlParams = new URLSearchParams(window.location.search)
        if (urlParams.has('category_ids') || urlParams.has('category_type')) {
            this.toggleCategories()
        }
    }

    /**
     * Toggle the tech stack dropdown
     */
    toggleTechStack() {
        const isHidden = this.techStackContentTarget.classList.contains('hidden')

        if (isHidden) {
            this.techStackContentTarget.classList.remove('hidden')
            this.techStackToggleTextTarget.textContent = 'Hide'
            this.techStackToggleIconTarget.classList.add('rotate-180')
        } else {
            this.techStackContentTarget.classList.add('hidden')
            this.techStackToggleTextTarget.textContent = 'Show'
            this.techStackToggleIconTarget.classList.remove('rotate-180')
        }
    }

    /**
     * Toggle the categories dropdown
     */
    toggleCategories() {
        const isHidden = this.categoriesContentTarget.classList.contains('hidden')

        if (isHidden) {
            this.categoriesContentTarget.classList.remove('hidden')
            this.categoriesToggleTextTarget.textContent = 'Hide'
            this.categoriesToggleIconTarget.classList.add('rotate-180')
        } else {
            this.categoriesContentTarget.classList.add('hidden')
            this.categoriesToggleTextTarget.textContent = 'Show'
            this.categoriesToggleIconTarget.classList.remove('rotate-180')
        }
    }

    /**
     * Update the category list when category type is changed
     * @param {Event} event - The change event
     */
    updateCategoryList(event) {
        const selectedType = event.target.value
        this.updateCategoryVisibility(selectedType)
    }

    /**
     * Show/hide category groups based on selected type
     * @param {String} selectedType - The selected category type
     */
    updateCategoryVisibility(selectedType = null) {
        const categoryGroups = document.querySelectorAll('.category-group')

        categoryGroups.forEach(group => {
            const groupType = group.dataset.categoryType

            if (!selectedType || selectedType === groupType) {
                group.classList.remove('hidden')
            } else {
                group.classList.add('hidden')
            }
        })
    }

    /**
     * Filter the technology list based on search input
     * @param {Event} event - The input event
     */
    searchTechnologies(event) {
        const searchTerm = event.target.value.toLowerCase().trim()
        const techItems = this.technologyListTarget.querySelectorAll('.tech-item')

        techItems.forEach(item => {
            const techName = item.dataset.techName

            if (!searchTerm || techName.includes(searchTerm)) {
                item.classList.remove('hidden')
            } else {
                item.classList.add('hidden')
            }
        })
    }
} 