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
    dancer: String,
  };

  filter() {
    const url = `${window.location.pathname}?${this.params}`;
    const filters_url = `${window.location.pathname}videos/filters/?${this.params}`;

    this.getBack();
    this.replaceContens(url);
    this.replaceFilters(filters_url);
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
    let dancerParam = ["dancer", this.dancerValue];
    let extraParams = [
      sortParam,
      directionParam,
      hdParam,
      watchedParam,
      clearParam,
      likedParam,
      dancerParam,
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

  async replaceContens(url) {
    const request = new FetchRequest("get", url, { responseKind: "html" });
    const response = await request.perform();
    if (response.ok) {
      const data = await response.html;
      var parser = new DOMParser();
      var parsedData = parser.parseFromString(data, "text/html");

      const replaceContainers = [
        "videos",
        "next_link",
        "button-filter",
        "button-sorting",
        "menu-additional-filters",
        "menu-sorting-filters",
        "button-clear-all",
        "videos-header",
      ];

      replaceContainers.forEach((element) => {
        document.getElementById(element).outerHTML = parsedData.getElementById(
          element
        ).outerHTML;
      });

      history.pushState({}, "", `${window.location.pathname}?${this.params}`);
    }
  }

  async replaceFilters(url) {
    const request = new FetchRequest("get", url, { responseKind: "html" });
    const response = await request.perform();
    if (response.ok) {
      const data = await response.html;
      var parser = new DOMParser();
      var parsedData = parser.parseFromString(data, "text/html");

      const replaceContainers = [
        "genre-filter",
        "leader-filter",
        "follower-filter",
        "orchestra-filter",
        "year-filter",
      ];

      replaceContainers.forEach((element) => {
        document.getElementById(element).outerHTML = parsedData.getElementById(
          element
        ).outerHTML;
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
