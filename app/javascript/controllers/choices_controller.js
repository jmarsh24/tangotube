import { Controller } from 'stimulus'
import * as Choices from 'choices.js'

export default class extends Controller {

  static targets = ['select', 'options']

  initialize() {
    this.element['choices'] = this
    this.refresh = this.refresh.bind(this)
    this.add = this.add.bind(this)
    this.remove = this.remove.bind(this)
    this.search = this.search.bind(this)
    this.update = this.update.bind(this)
    this.filter = this.filter.bind(this)
    this.options = this.options.bind(this)
    this.optionsReducer = this.optionsReducer.bind(this)
    this.searchPath = this.element.dataset.searchPath
    this.forceOption = this.element.dataset.forceOption || true
  }

  connect() {
    setTimeout(this.setup.bind(this), 5)
    console.log('Choices Controller ON')
  }

  setup() {
    this.choices = new Choices(this.selectTarget, {
  ...this.options(),
    callbackOnInit: function () {
    this.showDropdown()
  }
})
    this.input = this.element.querySelector('input')
    this.refresh()
    if (this.searchPath) this.input.addEventListener('input', this.search)
    this.selectTarget.addEventListener('change', this.refresh)
    this.selectTarget.addEventListener('addItem', this.add)
    this.selectTarget.addEventListener('removeItem', this.remove)
  }

  disconnect() {
    if (this.searchPath) this.input.removeEventListener('input', this.search)
    this.selectTarget.removeEventListener('change', this.refresh)
    this.selectTarget.removeEventListener('addItem', this.add)
    this.selectTarget.removeEventListener('removeItem', this.remove)
    try {
      this.choices.destroy()
    } catch { }
    this.choices = undefined
  }

  refresh() {
    this.choices.setChoices([], 'value', 'label', true)
    if (this.hasOptionsTarget) {
      ;[...this.optionsTarget.children].forEach(this.append.bind(this))
    }
  }

  append(option) {
    if (
      ![...this.selectTarget.options].some(o => {
        return o.label === option.label
      })
    )
      this.choices.setChoices([option], 'value', 'label', false)
  }
  add(event) {
    if (this.hasOptionsTarget) {
      const option = [...this.optionsTarget.children].find(option => {
        return option.label === event.detail.label
      })
      if (option) {
        option.setAttribute('selected', '')
      } else {
        const newOption = document.createElement('option')
        newOption.setAttribute('label', event.detail.label)
        newOption.setAttribute('value', event.detail.value)
        newOption.setAttribute('selected', '')
        this.optionsTarget.appendChild(newOption)
      }
    }
  }

  remove(event) {
    if (this.hasOptionsTarget) {
      const option = [...this.optionsTarget.children].find(item => {
        return item.label === event.detail.label
      })
      if (option)
        this.searchPath ? option.remove() : option.removeAttribute('selected')
    }
    if (this.forceOption && !this.selectTarget.options.length)
      this.selectTarget.add(document.createElement('option'))
  }

  search(event) {
    if (event.target.value) {
      fetch(this.searchPath + event.target.value, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      })
        .then(response => response.json())
        .then(this.update)
    } else {
      this.refresh()
    }
  }

  update(data) {
    this.choices.setChoices(data.filter(this.filter), 'value', 'label', true)
  }

  filter(item) {
    return ![...this.selectTarget.options].some(option => {
      return option.label === item.label
    })
  }

  options() {
    return 'silent renderChoiceLimit maxItemCount addItems removeItems removeItemButton editItems duplicateItemsAllowed delimiter paste searchEnabled searchChoices searchFloor searchResultLimit position resetScrollPosition addItemFilter shouldSort shouldSortItems placeholder placeholderValue prependValue appendValue renderSelectedChoices loadingText noResultsText noChoicesText itemSelectText addItemText maxItemText'
      .split(' ')
      .reduce(this.optionsReducer, {})
  }

  optionsReducer(accumulator, currentValue) {
    if (this.element.dataset[currentValue])
      accumulator[currentValue] = this.element.dataset[currentValue]
    return accumulator
  }
}