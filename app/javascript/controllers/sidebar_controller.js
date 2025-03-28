import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"];

  connect () {
    console.log("sidebar")
  }

  toggle() {
    console.log("Sidebar toggle clicked");
    this.sidebarTarget.classList.toggle('-translate-x-full')
  } 

}
