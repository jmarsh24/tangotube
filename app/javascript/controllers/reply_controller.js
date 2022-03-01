<<<<<<< HEAD
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  toggle(event) {
    event.preventDefault();
    this.formTarget.classList.toggle("isHidden");
=======
// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form" ]

  //connect() {
    //this.outputTarget.textContent = 'Hello, Stimulus!'
  //}

  toggle(event) {
    event.preventDefault()
    this.formTarget.classList.toggle("isHidden")
>>>>>>> bbd9037afad8b97e909dc091022630e97cd9486b
  }
}
