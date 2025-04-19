import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = [ 'form', 'sort_by' ] 

  connect () {
    console.log("animals")
  }

  sortAnimals() {
    let sort_by = this.sort_byTarget.value
    console.log(sort_by)
    get(`/medical_procedures/sort_animals/${sort_by}`, {
      responseKind: "turbo-stream"
    })
  } 

}