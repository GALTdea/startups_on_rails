import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        if (window.innerWidth < 768) {
            this.observeScroll()
        }
    }

    observeScroll() {
        const observer = new IntersectionObserver(
            ([entry]) => {
                if (!entry.isIntersecting) {
                    this.element.classList.add('shadow-md')
                } else {
                    this.element.classList.remove('shadow-md')
                }
            },
            { threshold: 1 }
        )

        observer.observe(this.element)
    }
} 