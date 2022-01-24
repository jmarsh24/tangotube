import { Controller } from "stimulus";

export default class extends Controller {
static targets = ["filterButton",
                  "sortButton",
                  "sort",
                  "filter",
                  "toggleable",
                  "sideNavContainer",
                  "mainSectionContainer",
                  "disableable"];

  toggle() {
    this.toggleableTarget.classList.toggle("isHidden");
  }

  toggleSort() {
    this.sortTarget.classList.toggle("isHidden");
    this.sortButtonTarget.classList.toggle("isActive");

    if (!this.filterTarget.classList.contains("isHidden")) {
      this.filterTarget.classList.add("isHidden")
      this.filterButtonTarget.classList.remove("isActive");
    }
  }

  toggleFilter() {
    this.filterTarget.classList.toggle("isHidden");
    this.filterButtonTarget.classList.toggle("isActive");

    if (!this.sortTarget.classList.contains("isHidden")) {
      this.sortTarget.classList.add("isHidden")
      this.sortButtonTarget.classList.remove("isActive");
    }
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
