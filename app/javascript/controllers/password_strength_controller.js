import { Controller } from "@hotwired/stimulus"

// Password strength controller
// This controller handles the password strength indicator
export default class extends Controller {
    static targets = ["input", "meter", "feedback"]

    connect() {
        // Initialize the password strength indicator
        if (this.hasInputTarget) {
            this.checkStrength()
        }
    }

    checkStrength() {
        const password = this.inputTarget.value
        const strength = this.calculatePasswordStrength(password)

        // Update the meter width and color
        this.updateMeter(strength)

        // Update the feedback text
        this.updateFeedback(strength)
    }

    calculatePasswordStrength(password) {
        if (!password) return 0

        let strength = 0

        // Length check
        if (password.length >= 8) strength += 1
        if (password.length >= 12) strength += 1

        // Character type checks
        if (/[A-Z]/.test(password)) strength += 1  // Has uppercase
        if (/[a-z]/.test(password)) strength += 1  // Has lowercase
        if (/[0-9]/.test(password)) strength += 1  // Has number
        if (/[^A-Za-z0-9]/.test(password)) strength += 1  // Has special char

        return Math.min(strength, 5)  // Max strength is 5
    }

    updateMeter(strength) {
        if (!this.hasMeterTarget) return

        // Calculate percentage (0-100)
        const percentage = (strength / 5) * 100

        // Update width
        this.meterTarget.style.width = `${percentage}%`

        // Update color based on strength
        const colors = {
            0: "bg-red-500",      // Very weak
            1: "bg-red-500",      // Weak
            2: "bg-orange-500",   // Fair
            3: "bg-yellow-500",   // Good
            4: "bg-green-500",    // Strong
            5: "bg-green-600"     // Very strong
        }

        // Remove all color classes
        this.meterTarget.classList.remove(
            "bg-red-500", "bg-orange-500", "bg-yellow-500", "bg-green-500", "bg-green-600"
        )

        // Add the appropriate color class
        this.meterTarget.classList.add(colors[strength])
    }

    updateFeedback(strength) {
        if (!this.hasFeedbackTarget) return

        const messages = {
            0: "Password strength: Too weak",
            1: "Password strength: Weak",
            2: "Password strength: Fair",
            3: "Password strength: Good",
            4: "Password strength: Strong",
            5: "Password strength: Very strong"
        }

        this.feedbackTarget.textContent = messages[strength]

        // Update feedback color to match meter
        const colors = {
            0: "text-red-600",
            1: "text-red-600",
            2: "text-orange-600",
            3: "text-yellow-600",
            4: "text-green-600",
            5: "text-green-700"
        }

        // Remove all color classes
        this.feedbackTarget.classList.remove(
            "text-gray-500", "text-red-600", "text-orange-600", "text-yellow-600", "text-green-600", "text-green-700"
        )

        // Add the appropriate color class
        this.feedbackTarget.classList.add(colors[strength])
    }
} 