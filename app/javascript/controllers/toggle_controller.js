import { Controller } from "stimulus";

export default class extends Controller {
static targets = ["toggleable"];

  connect() {
    console.log("Toggle-Controller ON");
  }


  toggle() {
    console.log("clicked");
    this.toggleableTarget.classList.toggle("is-hidden");
  }
}
