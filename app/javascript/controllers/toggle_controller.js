import { Controller } from "stimulus";

export default class extends Controller {
static targets = ["filterButton",
                  "filter",
                  "toggleable",
                  "sideNavContainer",
                  "mainSectionContainer",
                  "disableable"];

  toggle() {
    this.toggleableTarget.classList.toggle("isHidden");
  }

  toggleFilter() {
    this.filterTarget.classList.toggle("isHidden");
    this.filterButtonTarget.classList.toggle("isActive");
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
