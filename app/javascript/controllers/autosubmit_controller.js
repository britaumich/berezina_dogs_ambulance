import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form', 'sidebar' ]
  
  connect () {
    console.log("connect autosubmit")
  }

  clearFilters() {
    console.log("clear filters")
    var url = window.location.pathname
    Turbo.visit(url)
  }

  search() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      Turbo.navigator.submitForm(this.formTarget)
    }, 200)
  }
  
  submit() {
    console.log("here")
    Turbo.navigator.submitForm(this.formTarget)
  }

  toggle() {
    console.log("Sidebar toggle clicked");
    this.sidebarTarget.classList.toggle('-translate-x-full')
  }
}
