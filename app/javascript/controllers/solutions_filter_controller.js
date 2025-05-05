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
        "categoriesToggleIcon",
        "modal",
        "categoryTypeInput"
    ]

    connect() {
        console.log("From solutions filter controller")
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

    /**
     * Open the modal for more filters
     */
    openModal() {
        console.log('openModal method called');
        if (this.hasModalTarget) {
            console.log('Modal target found');
            this.modalTarget.classList.remove('hidden');
        } else {
            console.error('Modal target not found!');
            console.log('Available targets:', this.targets);

            // Fallback to document.querySelector if the target isn't found
            const modal = document.getElementById('filters-modal');
            if (modal) {
                console.log('Found modal via document.getElementById');
                modal.classList.remove('hidden');
            } else {
                console.error('Modal not found at all!');
            }
        }
    }

    /**
     * Close the modal for more filters
     */
    closeModal() {
        if (this.hasModalTarget) {
            this.modalTarget.classList.add('hidden')
        }
    }

    /**
     * Handle selection of category type via pill buttons
     * @param {Event} event - The click event
     */
    selectCategoryType(event) {
        const selectedType = event.currentTarget.dataset.categoryType;

        // Update the hidden input value
        if (this.hasCategoryTypeInputTarget) {
            this.categoryTypeInputTarget.value = selectedType;
        }

        // Update the UI
        this.updateCategoryVisibility(selectedType);

        // Update active state of pills
        const pills = document.querySelectorAll('[data-action="click->solutions-filter#selectCategoryType"]');
        pills.forEach(pill => {
            if (pill.dataset.categoryType === selectedType) {
                pill.classList.add('bg-blue-100', 'text-blue-800');
                pill.classList.remove('bg-gray-100', 'text-gray-600', 'hover:bg-gray-200');
            } else {
                pill.classList.remove('bg-blue-100', 'text-blue-800');
                pill.classList.add('bg-gray-100', 'text-gray-600', 'hover:bg-gray-200');
            }
        });
    }
} 