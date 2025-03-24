import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["sheet"]

    connect() {
        this.originalHeight = window.innerHeight
    }

    open(event) {
        event.preventDefault()
        document.body.classList.add('bottom-sheet-open')
        this.sheetTarget.classList.remove('hidden')
        requestAnimationFrame(() => {
            this.sheetTarget.classList.remove('opacity-0', 'scale-95')
            this.sheetTarget.classList.add('opacity-100', 'scale-100')
        })
    }

    close(event) {
        event.preventDefault()
        document.body.classList.remove('bottom-sheet-open')
        this.sheetTarget.classList.add('opacity-0', 'scale-95')
        setTimeout(() => {
            this.sheetTarget.classList.add('hidden')
        }, 200)
    }
} 