import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="animal"
export default class extends Controller {
  static targets = ['aviary_select', 'show_sections', 'section']
  connect() {
    console.log("connect animal")
  }

  getSections () {
    console.log("getSections")
    let aviary = this.aviary_selectTarget.value
    fetch(`/aviaries/get_sections/${aviary}`)
    .then((response) => response.json())
    .then((data) => this.updateSections(data)
  );
  }

  updateSections(data) {
    console.log("updateSections")
    console.log(data)
    if (data.length > 0) {
      this.show_sectionsTarget.classList.remove('hidden')
    } else {
      this.show_sectionsTarget.classList.add('hidden')
    }
    let dropdown = this.sectionTarget;
    dropdown.length = 0;

    let defaultOption = document.createElement('option');
    defaultOption.value = '';
    if (data.length > 1) {
      console.log("more that one")
      defaultOption.text = 'Select Section ...';
      dropdown.add(defaultOption);
      dropdown.selectedIndex = 0;
      let option;
      for (let i = 0; i < data.length; i++) {
        option = document.createElement('option');
        option.value = data[i][0];
        option.text = data[i][1];
        dropdown.add(option);
      }
    } else if (data.length == 1) {
      dropdown.selectedIndex = 0;
      let option;
      option = document.createElement('option');
      option.value = data[0][0];
      option.text = data[0][1];
      dropdown.add(option);
    } else {
      defaultOption.text = 'No sections for this aviary';
      dropdown.add(defaultOption);
    }
  }

}
