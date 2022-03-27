import { Controller } from "@hotwired/stimulus";
import { FetchRequest } from "@rails/request.js";

export default class extends Controller {
  static targets = ["filter"];
  static values = {
    sort: String,
    direction: String,
    hd: String,
    watched: String,
    clear: String,
    liked: String,
  };

  filter() {
    const url = `${window.location.pathname}?${this.params}`;

    this.getBack();
    this.replaceContents(url);
  }

  get params() {
    const queryString = window.location.search;
    let searchParams = new URLSearchParams(queryString);

    this.setCurrentParams(searchParams);
    this.deleteEmptyParams(searchParams);

    if (searchParams.get("clear") == 1) {
      return "";
    } else {
      return searchParams.toString();
    }
  }

  setCurrentParams(searchParams) {
    let params = this.filterTargets.map((t) => [t.name, t.value]);

    let sortParam = ["sort", this.sortValue];
    let directionParam = ["direction", this.directionValue];
    let hdParam = ["hd", this.hdValue];
    let watchedParam = ["watched", this.watchedValue];
    let clearParam = ["clear", this.clearValue];
    let likedParam = ["liked", this.likedValue];
    let extraParams = [
      sortParam,
      directionParam,
      hdParam,
      watchedParam,
      clearParam,
      likedParam,
    ];

    extraParams.forEach((element) => {
      if (element[1]) {
        searchParams.set(element[0], element[1]);
      }
    });

    params.forEach((param) => searchParams.set(param[0], param[1]));

    return searchParams;
  }

  deleteEmptyParams(searchParams) {
    let keysForDel = [];
    searchParams.forEach((v, k) => {
      if (v == "" || k == "" || v == "0") keysForDel.push(k);
    });
    keysForDel.forEach((k) => {
      searchParams.delete(k);
    });
    return searchParams;
  }

  async replaceContents(url) {
    const request = new FetchRequest("get", url, { responseKind: "html" });
    const response = await request.perform();
    if (response.ok) {
      const data = await response.html;
      var parser = new DOMParser();
      var parsedData = parser.parseFromString(data, "text/html");

      const replaceContainers = [
        "filters",
        "videos",
        "next_link",
        "videos-header",
      ];

      replaceContainers.forEach((element) => {
        document.getElementById(element).innerHTML = parsedData.getElementById(
          element
        ).innerHTML;
      });

      history.pushState({}, "", `${window.location.pathname}?${this.params}`);
    }
  }

  getBack() {
    window.onpopstate = function () {
      Turbo.visit(document.location);
    };
  }
}
