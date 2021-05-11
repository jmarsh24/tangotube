import { Controller } from "stimulus";

export default class extends Controller {
static targets = ["toggleable", "sideNavContainer", "mainSectionContainer", "disableable"];

  toggle() {
    this.toggleableTarget.classList.toggle("isHidden");
  }

  navShowHide() {
      this.sideNavContainerTarget.classList.toggle('isHidden')
      this.mainSectionContainerTarget.classList.toggle('leftPadding')
  }

  disableFilters() {
    const ssfilterListItems = document.getElementsByClassName("ss-list")
    const ssfilterContainer = document.getElementsByClassName('ss-content ss-open')

    Array.from(ssfilterListItems).forEach(element => element.classList.toggle('disabled'))
    Array.from(ssfilterContainer).forEach(element => element.classList.toggle('disabled'))
  }
}
