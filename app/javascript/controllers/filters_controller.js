import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filters"
export default class extends Controller {
  connect() {
  }

  clearFilters() {
    this.element.reset()
  }
}
