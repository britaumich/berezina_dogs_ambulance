// app/javascript/controllers/select_controller.js
import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {

  connect() {
    new TomSelect(
      this.element, {
        create: (input, callback) => {
          // "input" is the entered value
          alert(`trying to create ${input}`)
        },
      }
    )
  }
}
