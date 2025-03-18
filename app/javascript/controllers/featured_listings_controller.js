import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["item"]
    static values = {
        url: String
    }

    connect() {
        this.draggedItem = null
        this.setupDragAndDrop()
    }

    setupDragAndDrop() {
        this.itemTargets.forEach(item => {
            item.addEventListener('dragstart', this.handleDragStart.bind(this))
            item.addEventListener('dragend', this.handleDragEnd.bind(this))
            item.addEventListener('dragover', this.handleDragOver.bind(this))
            item.addEventListener('drop', this.handleDrop.bind(this))
        })
    }

    handleDragStart(e) {
        this.draggedItem = e.target
        e.target.classList.add('opacity-50')
    }

    handleDragEnd(e) {
        e.target.classList.remove('opacity-50')
        this.draggedItem = null
    }

    handleDragOver(e) {
        e.preventDefault()
        const afterElement = this.getDragAfterElement(this.element, e.clientY)
        const draggable = this.draggedItem

        if (afterElement) {
            this.element.insertBefore(draggable, afterElement)
        } else {
            this.element.appendChild(draggable)
        }
    }

    handleDrop(e) {
        e.preventDefault()
        this.updatePositions()
    }

    getDragAfterElement(container, y) {
        const draggableElements = [...container.querySelectorAll('[data-featured-listings-target="item"]:not(.opacity-50)')]

        return draggableElements.reduce((closest, child) => {
            const box = child.getBoundingClientRect()
            const offset = y - box.top - box.height / 2

            if (offset < 0 && offset > closest.offset) {
                return { offset: offset, element: child }
            } else {
                return closest
            }
        }, { offset: Number.NEGATIVE_INFINITY }).element
    }

    async updatePositions() {
        const items = this.itemTargets
        const positions = items.map((item, index) => ({
            id: item.dataset.id,
            position: index
        }))

        try {
            const response = await fetch(this.urlValue, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({ positions })
            })

            if (!response.ok) throw new Error('Failed to update positions')
        } catch (error) {
            console.error('Error updating positions:', error)
            // Optionally show an error message to the user
        }
    }
} 