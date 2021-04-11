// filters_controller.js
import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["filter"]

  filter() {
    const url = `${window.location.pathname}?${this.params}`;

    Rails.ajax({
     type: "get",
     url: url,
     success: (data) => {

      const newContainerFilters = data.getElementById('filter-container-upper')
      const containerFilters = document.getElementById('filter-container-upper')
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

      containerFilters.innerHTML = newContainerFilters.innerHTML
      containerVideos.innerHTML = newContainerVideos.innerHTML
      containerLoadmore.innerHTML = newContainerLoadmore.innerHTML
      containerFilterresults.innerHTML = newContainerFilterresults.innerHTML
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
    let usp = new URLSearchParams(queryString)

      this.setCurrentParams(usp)
      this.deleteEmptyParams(usp)

    return usp.toString()
  }

  setCurrentParams(usp) {
    let params = this.filterTargets.map(t => [t.name, t.value])

    params.forEach(param => usp.set(param[0], param[1]))

    return usp
  }

  deleteEmptyParams(usp) {
    let keysForDel = []
      usp.forEach((v, k) => {
        if (v == '' || k == '') keysForDel.push(k)
      })
      keysForDel.forEach(k => {
        usp.delete(k)
      })
      return usp
  }
}
