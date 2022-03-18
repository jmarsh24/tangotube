import { Controller } from "@hotwired/stimulus"
import { SlDrawer } from "@shoelace-style/shoelace"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["drawer"]

  drawerTarget: SlDrawer

  show() {
    this.drawerTarget.show()
  }

  hide() {
    this.drawerTarget.hide()
  }
}
