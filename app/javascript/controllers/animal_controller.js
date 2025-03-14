import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="animal"
export default class extends Controller {
  static targets = ['form', 'aviary_select', 'show_sections', 'section',
    'birth_year', 'birth_month', 'birth_day',
    'death_year', 'death_month', 'death_day']

  connect() {
    console.log("connect animal")
  }

  clearFilters() {
    console.log("clear filters")
    var url = window.location.pathname
    Turbo.visit(url)
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

  submitForm(event) {
    var error_scroll_place = document.getElementById('error_scroll_place')
    var birthdate_error = document.getElementById('birthdate_error')
    birthdate_error.innerHTML = ''
    let birth_year = this.birth_yearTarget.value
    let birth_month = this.birth_monthTarget.value
    let birth_day = this.birth_dayTarget.value

    let death_year = this.death_yearTarget.value
    let death_month = this.death_monthTarget.value
    let death_day = this.death_dayTarget.value
    var deathdate_error = document.getElementById('deathdate_error')
    deathdate_error.innerHTML = ''

    if (birth_month == '' && birth_day != ''){
      birthdate_error.innerHTML = "Месяц рождения не может быть пустым, если выбран день."
      error_scroll_place.scrollIntoView()
      event.preventDefault()
    }
    if (birth_day == '' && birth_month != ''){
      birthdate_error.innerHTML = "День рождения не может быть пустым, если выбран месяц."
      error_scroll_place.scrollIntoView()
      event.preventDefault()
    }
    if (birth_year == '' && (birth_month != '' || birth_day != '')) {
      birthdate_error.innerHTML = "Год рождения не может быть пустым, если выбраны день и месяц."
      error_scroll_place.scrollIntoView()
      event.preventDefault()
    }

    if (death_month == '' && death_day != ''){
      deathdate_error.innerHTML = "Месяц смерти не может быть пустым, если выбран день."
      error_scroll_place.scrollIntoView()
      event.preventDefault()
    }
    if (death_day == '' && death_month != ''){
      deathdate_error.innerHTML = "День смерти не может быть пустым, если выбран месяц."
      error_scroll_place.scrollIntoView()
      event.preventDefault()
    }
    if (death_year == '' && (death_month != '' || death_day != '')) {
      deathdate_error.innerHTML = "Год смерти не может быть пустым, если выбраны день и месяц."
      error_scroll_place.scrollIntoView()
      event.preventDefault()
    }
    // Turbo.navigator.submitForm(this.formTarget)
  }

}
