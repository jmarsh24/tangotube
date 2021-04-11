import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

export default class extends Controller {
  static targets = ['videos', 'loadmore']
  static values = { page: Number }

  loadMore () {
    const url = new URL(window.document.location)

    url.searchParams.set('page', this.pageValue)

    Rails.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: data => {
        document
          .getElementById('videos')
          .insertAdjacentHTML('beforeend', data.videos)
        document.getElementById('load-more-container').innerHTML = data.loadmore
      }
    })
  }
}
