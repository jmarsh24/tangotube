// filters_controller.js
import { Controller } from "stimulus"
import Rails from "@rails/ujs"
import { Turbo } from '@hotwired/turbo-rails'

export default class extends Controller {
  static targets = [ "filter" ]
  static values = { sort: String,
                    direction: String,
                    hd: String
                  }

  filter() {
    const url = `${window.location.pathname}?${this.params}`

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

        containerFilters.innerHTML = newContainerFilters.innerHTML
        containerVideos.innerHTML = newContainerVideos.innerHTML
        containerLoadmore.innerHTML = newContainerLoadmore.innerHTML
        containerFilterresults.innerHTML = newContainerFilterresults.innerHTML
        containerSorting.innerHTML = newContainerSorting.innerHTML

        history.pushState({}, '', `${window.location.pathname}?${this.params}`)
        window.onpopstate = function () {
          Turbo.visit(document.location)
        }
     },
     error: (data) => {
       console.log(data)
     }
   })
  }

  get params() {
    const queryString = window.location.search
    let searchParams = new URLSearchParams(queryString)

      this.setCurrentParams(searchParams)
      this.deleteEmptyParams(searchParams)

    return searchParams.toString()
  }

  setCurrentParams(searchParams) {
    let params = this.filterTargets.map(t => [t.name, t.value])

    let sortParam = ["sort", this.sortValue]
    let directionParam = ["direction", this.directionValue]
    let hdParam = ["hd", this.hdValue]

    if (sortParam[1]) {
      searchParams.set(sortParam[0], sortParam[1])
    }

    if (directionParam[1]) {
      searchParams.set(directionParam[0], directionParam[1])
    }

    if (hdParam[1]) {
      searchParams.set(hdParam[0], hdParam[1])
    }

    params.forEach(param => searchParams.set(param[0], param[1]))

    return searchParams
  }

  deleteEmptyParams(searchParams) {
    let keysForDel = []
      searchParams.forEach((v, k) => {
        if (v == '' || k == '' || v == '0') keysForDel.push(k)
      })
      keysForDel.forEach(k => {
        searchParams.delete(k)
      })
      return searchParams
  }
}
