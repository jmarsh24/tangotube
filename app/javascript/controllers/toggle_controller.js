import { Controller } from "stimulus";

export default class extends Controller {
static targets = ["toggleable"];

  connect() {
    console.log("Toggle-Controller ON");
  }

  initialize() {
    this.toggleableTarget.classList.toggle('hidden')
    var select2 = document.querySelectorAll('.select2-container')
    select2.forEach(element => element.classList.toggle('hidden'))
  }

  toggle() {
    console.log("clicked");
    this.toggleableTarget.classList.toggle("hidden");
    var select2 = document.querySelectorAll('.select2-container');
    select2.forEach(element => element.classList.toggle('hidden'));
  }
}
