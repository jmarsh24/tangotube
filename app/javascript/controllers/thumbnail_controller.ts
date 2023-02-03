import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="thumbnail"
export default class extends Controller {
  static targets = ["image"];
  static values = {
    url: String,
  };

  check() {
    var image = this.imageTarget;
    var url = this.urlValue;
    var thumbnail = [
      "maxresdefault",
      "mqdefault",
      "sddefault",
      "hqdefault",
      "default",
    ];
    if (image.naturalWidth === 120 && image.naturalHeight === 90) {
      for (var i = 0, len = thumbnail.length - 1; i < len; i++) {
        if (url.indexOf(thumbnail[i]) > 0) {
          image.setAttribute(
            "src",
            url.replace(thumbnail[i], thumbnail[i + 1])
          );
          break;
        }
      }
    }
  }
}
