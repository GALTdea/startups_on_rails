import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form"]

    connect() {
        this.timeout = null
    }

    submit(event) {
        event.preventDefault()

        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            const form = event.target.closest('form')
            const formData = new FormData(form)
            const url = new URL(form.action, window.location.origin)

            // Append form data to URL
            for (const [key, value] of formData.entries()) {
                if (value) {
                    url.searchParams.append(key, value)
                }
            }

            // Use Turbo to visit the URL
            Turbo.visit(url, { frame: "search_results" })
        }, 300)
    }
} 