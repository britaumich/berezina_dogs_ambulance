import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["deleteButton", "warningMessage"]
  static values = { 
    isMainPicture: Boolean,
    totalPictures: Number
  }

  connect() {
    console.log("PictureDeleteController connected")
    this.hideWarning()
  }

  checkDelete(event) {
    if (this.isMainPictureValue && this.totalPicturesValue > 1) {
      event.preventDefault()
      this.showWarning()
      return false
    }
    return true
  }

  showWarning() {
    if (this.hasWarningMessageTarget) {
      this.warningMessageTarget.classList.remove("hidden")
    }
  }

  hideWarning() {
    if (this.hasWarningMessageTarget) {
      this.warningMessageTarget.classList.add("hidden")
    }
  }
}
