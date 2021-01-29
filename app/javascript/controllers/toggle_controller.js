import { Controller } from "stimulus";

export default class extends Controller {
static targets = ["toggleable", "sideNavContainer", "mainSectionContainer"];

  connect() {
    console.log("Toggle-Controller ON");
  }

  toggle() {
    console.log("clicked");
    this.toggleableTarget.classList.toggle("isHidden");
  }

  navShowHide() {
      console.log('clicked')
      this.sideNavContainerTarget.classList.toggle('isHidden')
      this.mainSectionContainerTarget.classList.toggle('leftPadding')
  }
}
