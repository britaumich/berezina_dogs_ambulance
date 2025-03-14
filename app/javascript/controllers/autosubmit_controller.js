import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form']
  
  connect () {
    console.log("connect")
  }

  clearFilters() {
    console.log("clear filters")
    var url = window.location.pathname
    Turbo.visit(url)
  }
  
  submit() {
    console.log("here")
    Turbo.navigator.submitForm(this.formTarget)
  }
}
