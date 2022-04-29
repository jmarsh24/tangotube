import { Controller } from "@hotwired/stimulus";
import Swiper, { Navigation, Pagination } from "swiper";

// Connects to data-controller="banner"
export default class extends Controller {
  static targets = ["banner"];

  connect() {
    swiper = new Swiper(this.bannerTarget, {
      modules: [Navigation, Pagination],
      centeredSlides: true,
      loop: true,
      autoplay: {
        delay: 1000,
        disableOnInteraction: true,
      },

      pagination: {
        el: ".swiper-pagination",
        clickable: true,
      },

      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
    });
  }
}
