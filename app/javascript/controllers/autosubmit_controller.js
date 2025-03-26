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

  search() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 200)
  }
  
  submit() {
    console.log("here")
    Turbo.navigator.submitForm(this.formTarget)
  }
}
