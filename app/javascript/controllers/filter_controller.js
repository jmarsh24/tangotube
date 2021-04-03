// filters_controller.js
import { Controller } from "stimulus"
import Rails from "@rails/ujs"
import * as Turbo from '@hotwired/turbo'

export default class extends Controller {
  static targets = ["filter"]

  filter() {
    const url = `${window.location.pathname}?${this.params}`;

    Rails.ajax({
     type: "get",
     url: url,
     success: (data) => {
       const newContainerGenreFilters = data.getElementById('genre-filter')
       const containerGenreFilters = document.getElementById('genre-filter')
       const newContainerLeaderFilters = data.getElementById('leader-filter')
       const containerLeaderFilters = document.getElementById('leader-filter')
       const newContainerFollowerFilters = data.getElementById('follower-filter')
       const containerFollowerFilters = document.getElementById('follower-filter')
       const newContainerOrchestraFilters = data.getElementById("orchestra-filter")
       const containerOrchestraFilters = document.getElementById("orchestra-filter")
       const newContainerYearFilters = data.getElementById('year-filter')
       const containerYearFilters = document.getElementById('year-filter')

       const newContainerVideos = data.getElementById('videos')
       const containerVideos = document.getElementById('videos')
       const newContainerLoadmore = data.getElementById('load-more-container')
       const containerLoadmore = document.getElementById('load-more-container')
       const newContainerFilterresults = data.getElementById('filter_results')
       const containerFilterresults = document.getElementById('filter_results')

       containerGenreFilters.innerHTML = newContainerGenreFilters.innerHTML
       containerLeaderFilters.innerHTML = newContainerLeaderFilters.innerHTML
       containerFollowerFilters.innerHTML = newContainerFollowerFilters.innerHTML
       containerOrchestraFilters.innerHTML = newContainerOrchestraFilters.innerHTML
       containerVideos.innerHTML = newContainerVideos.innerHTML
       containerLoadmore.innerHTML = newContainerLoadmore.innerHTML
       containerFilterresults.innerHTML = newContainerFilterresults.innerHTML
       containerYearFilters.innerHTML = newContainerYearFilters.innerHTML

       history.pushState({}, '', `${window.location.pathname}?${this.params}`)
     },
     error: (data) => {
       console.log(data)
     }
   })
  }

  get params() {
    const queryString = window.location.search
    const urlParams = new URLSearchParams(queryString)
    let search = document.querySelector('#query')
    let songID = urlParams.getAll('song_id')
    let eventID = urlParams.getAll('event_id')
    let hd = urlParams.getAll('hd')
    let params = this.filterTargets
      .filter((t) => t.value !== '')
      .filter((t) => t.name!== '')
      .map((t) => `${t.name}=${t.value}`)

    if (search.value) {
      params.push(`${search.name}=${search.value}`)
    }

    if (songID.length > 0 ) {
      params.push(`song_id=${songID}`)
    }

    if (eventID.length > 0) {
      params.push(`event_id=${eventID}`)
    }

    if (hd.length > 0) {
      params.push(`hd=${hd}`)
    }

    return [...new Set(params)].join("&")

  }
}
