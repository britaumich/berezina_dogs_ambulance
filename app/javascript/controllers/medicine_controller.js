import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = [ 'form', 'sort_by', 'checkbox', 'date_planned' ] 

  connect () {
    console.log("connect medicine")
  }

  sortAnimals() {
    let sort_by = this.sort_byTarget.value
    get(`/medical_procedures/sort_animals/${sort_by}`, {
      responseKind: "turbo-stream"
    })
  }

  submitForm(event) {
    var checkbox_error_place = document.getElementById('checkbox_error')
    checkbox_error_place.innerHTML = ''
    var date_planned_error_place = document.getElementById('date_planned_error')
    date_planned_error_place.innerHTML = ''
    var date_planned = this.date_plannedTarget.value
    if (!this.checkboxTargets.map(x => x.checked).includes(true)) {
      checkbox_error_place.innerHTML = "Пожалуйста, выберите имена."
      event.preventDefault()
    } else {
      checkbox_error_place.innerHTML = ''
    }
    if (date_planned == "") {
      date_planned_error_place.innerHTML = "Пожалуйста, выберите дату по плану."
      event.preventDefault()
    } else {
      date_planned_error_place.innerHTML = ''
    }
  }

}