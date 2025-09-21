import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectAll", "select", "selectedCount", "disablable"]

  get selected() {
    return this.selectTargets.filter(x => x.checked).map(x => x.value)
  }

  #update = () => {
    const allDisabled = (this.selected.length === 0)
    const indeterminate = !allDisabled && this.selected.length !== this.selectTargets.length
    
    this.selectAllTarget.indeterminate = indeterminate
    this.selectAllTarget.checked = !allDisabled && !indeterminate

    this.selectedCountTargets.forEach(x => x.innerText = this.selected.length)
    this.disablableTargets.forEach(x => {
      x.disabled = allDisabled
      x.dataset.disabled = allDisabled
    })
  }

  connect() {
    this.#update()
  }

  selectAll = (event) => {
    this.selectTargets.forEach((target) => {
      target.checked = event.target.checked
    })

    this.#update()
  }

  select = (event) => {
    this.#update()
  }
}
