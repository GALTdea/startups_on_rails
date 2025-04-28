import { Controller } from "@hotwired/stimulus"

/**
 * Solutions Filter Controller
 *
 * Handles dynamic filtering of solutions based on category types and selections
 */
export default class extends Controller {
    static targets = ["categoryGroup"]

    connect() {
        this.updateCategoryVisibility()
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
} 