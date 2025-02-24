import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["dropdown"]

    connect() {
        // Close dropdown when clicking outside
        document.addEventListener('click', this.handleClickOutside.bind(this))
    }

    disconnect() {
        document.removeEventListener('click', this.handleClickOutside.bind(this))
    }

    toggle(event) {
        event.stopPropagation()

        // Add transition classes
        if (this.dropdownTarget.classList.contains('hidden')) {
            this.dropdownTarget.classList.remove('hidden')
            this.dropdownTarget.classList.add('opacity-0', 'scale-95')

            // Force reflow
            this.dropdownTarget.offsetHeight

            this.dropdownTarget.classList.remove('opacity-0', 'scale-95')
            this.dropdownTarget.classList.add('opacity-100', 'scale-100')
        } else {
            this.dropdownTarget.classList.remove('opacity-100', 'scale-100')
            this.dropdownTarget.classList.add('opacity-0', 'scale-95')

            setTimeout(() => {
                this.dropdownTarget.classList.add('hidden')
            }, 100)
        }
    }

    handleClickOutside(event) {
        if (!this.element.contains(event.target)) {
            this.dropdownTarget.classList.add('hidden')
            this.dropdownTarget.classList.remove('opacity-100', 'scale-100')
        }
    }
} 