import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "toggleable" ] 

  connect() {
    console.log("navbar")
  }

  toggle() {
    this.toggleableTarget.classList.toggle('hidden')
  } 

}