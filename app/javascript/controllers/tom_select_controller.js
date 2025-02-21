import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
    connect() {
        new TomSelect(this.element, {
            plugins: ['remove_button', 'dropdown_input'],
            create: false,
            hideSelected: false,
            maxOptions: 50,
            onItemAdd: () => this.element.dispatchEvent(new Event('change')),
            onItemRemove: () => this.element.dispatchEvent(new Event('change'))
        })
    }
} 