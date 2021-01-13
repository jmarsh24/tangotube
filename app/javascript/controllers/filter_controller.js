// filters_controller.js
import { Controller } from "stimulus";
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["filter"];

  connect() {
    console.log("Filter-Controller ON");
  }

  filter() {
    console.log(window.location.pathname);
    const url = `${window.location.pathname}?${this.params}`;
    Turbolinks.clearCache();
    Turbolinks.visit(url);
  }

  // filter() {
  //   const url = `${window.location.pathname}?${this.params}`;

  //   Rails.ajax({
  //    type: "get",
  //    url: url,
  //    success: (data) => {
  //      const newContainerVideos = data.getElementById("videos");
  //      const containerVideos = document.getElementById("videos");
  //      const containerFilters = document.getElementById("filters");
  //      const newContainerFilters = data.getElementById("filters");
  //      const newContainerYoutubeVideo = data.getElementById("youtube_video");
  //      const containerYoutubeVideo = document.getElementById("youtube_video");
  //      const newContainerVideoDetails = data.getElementById("video_details");
  //      const containerVideoDetails = document.getElementById("video_details");
  //      containerVideos.innerHTML = newContainerVideos.innerHTML;
  //      containerFilters.innerHTML = newContainerFilters.innerHTML;
  //      containerYoutubeVideo.innerHTML = newContainerYoutubeVideo.innerHTML;
  //      containerVideoDetails.innerHTML = newContainerVideoDetails.innerHTML;
  //      history.pushState({}, '', `${window.location.pathname}?${this.params}`)
  //    },
  //    error: (data) => {
  //      console.log(data)
  //    }
  //  });
  // }

  get params() {
    let params = this.filterTargets
      .filter((t) => t.value !== "all")
      .map((t) => `${t.name}=${t.value}`);

    let search = document.querySelector("#query");
    params.push(`${search.name}=${search.value}`)

    return params.join("&");
  }
}
