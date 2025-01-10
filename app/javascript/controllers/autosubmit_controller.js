import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form']
  
  connect () {
    console.log("connect")
  }
  submit() {
    console.log("here")
    Turbo.navigator.submitForm(this.formTarget)
  }
}
