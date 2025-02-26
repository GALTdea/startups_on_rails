import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["item"]

    connect() {
        console.log("Selected Techs controller connected")
        this.updateSelectedTechs()

        // Listen for changes to checkboxes
        document.addEventListener('change', (event) => {
            if (event.target.name === 'company[technology_ids][]') {
                this.updateSelectedTechs()
            }
        })
    }

    updateSelectedTechs() {
        const selectedTechsContainer = document.getElementById('selected-technologies')
        const checkboxes = document.querySelectorAll('input[name="company[technology_ids][]"]:checked')

        // Clear existing items
        selectedTechsContainer.innerHTML = ''

        if (checkboxes.length === 0) {
            selectedTechsContainer.innerHTML = `
        <div class="text-center py-4 text-gray-500">
          No technologies selected. Please select technologies from the list above.
        </div>
      `
            return
        }

        // Add new items for each selected technology
        checkboxes.forEach(checkbox => {
            const techId = checkbox.value
            const techName = checkbox.nextElementSibling.textContent.trim()
            const techInitial = techName.charAt(0).toUpperCase()

            const techItem = document.createElement('div')
            techItem.className = 'border rounded-md p-4'
            techItem.dataset.selectedTechsTarget = 'item'

            techItem.innerHTML = `
        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <div class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center mr-3">
              <span class="text-gray-500 font-bold">${techInitial}</span>
            </div>
            <span class="font-medium">${techName}</span>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Proficiency Level</label>
            <select name="proficiency_levels[${techId}]" class="rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
              <option value="core">Core</option>
              <option value="regular" selected>Regular</option>
              <option value="occasional">Occasional</option>
            </select>
          </div>
        </div>
      `

            selectedTechsContainer.appendChild(techItem)
        })
    }
} 