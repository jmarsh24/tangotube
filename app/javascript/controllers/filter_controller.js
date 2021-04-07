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
       const containerSorting = document.getElementById('sortable_container')
       const newContainerSorting = data.getElementById('sortable_container')
       const containerHd = document.getElementById('hd_filters')
       const newContainerHd = data.getElementById('hd_filters')


       containerGenreFilters.innerHTML = newContainerGenreFilters.innerHTML
       containerLeaderFilters.innerHTML = newContainerLeaderFilters.innerHTML
       containerFollowerFilters.innerHTML = newContainerFollowerFilters.innerHTML
       containerOrchestraFilters.innerHTML = newContainerOrchestraFilters.innerHTML
       containerVideos.innerHTML = newContainerVideos.innerHTML
       containerLoadmore.innerHTML = newContainerLoadmore.innerHTML
       containerFilterresults.innerHTML = newContainerFilterresults.innerHTML
       containerYearFilters.innerHTML = newContainerYearFilters.innerHTML
       containerSorting.innerHTML = newContainerSorting.innerHTML
       containerHd.innerHTML = newContainerHd.innerHTML

       history.pushState({}, '', `${window.location.pathname}?${this.params}`)
     },
     error: (data) => {
       console.log(data)
     }
   })
  }

  get params() {
    const queryString = window.location.search
    const usp = new URLSearchParams(queryString)

    console.log(this.filterTargets)

    let params = this.filterTargets.map((t) => [t.name, t.value])

    console.log(params)

      params.forEach((param) => usp.set(param[0], param[1]))

    console.log(usp.toString())

    let keysForDel = []
      usp.forEach((v, k) => {
        if (v == '' || v == '0' || k == '') keysForDel.push(k)
      })
      keysForDel.forEach(k => {
        usp.delete(k)
      })

    return usp.toString()
  }
}
