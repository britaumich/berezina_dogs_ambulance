import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Explicitly define the controller class and export it
export default class extends Controller {
  connect() {
    console.log("date contr")
    this.fp = flatpickr(this.element, {
      dateFormat: "d-m-Y",
      allowInput: false,
      altInput: false,
      required: true,
      disableMobile: true,
      onChange: (selectedDates, dateStr) => {
        console.log(dateStr)
        if (!dateStr) {
          this.element.setCustomValidity("Please select a date")
        } else {
          this.element.setCustomValidity("")
        }
      }
    })
  }

  disconnect() {
    this.fp.destroy()
  }
}
