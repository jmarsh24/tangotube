import { Controller } from '@hotwired/stimulus';

export default class NavbarController extends Controller {
  lastScrollTop: number = 0;

  connect() {
    this.lastScrollTop = 0;
    window.addEventListener('scroll', this.handleScroll.bind(this));
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll.bind(this));
  }

  handleScroll() {
    let scrollTop = window.scrollY || document.documentElement.scrollTop;

    // Check if the filter bar is present
    const filterBar = document.getElementById('filter-bar');

    if (scrollTop > this.lastScrollTop) {
      // downscroll code
      this.hideNavbar(filterBar);
    } else {
      // upscroll code
      this.showNavbar();
    }
    this.lastScrollTop = scrollTop <= 0 ? 0 : scrollTop; // For Mobile or negative scrolling
  }

  hideNavbar(filterBar: HTMLElement | null) {
    // Use the actual height of your navbar
    // this.element refers to the element this controller is connected to
    if (filterBar) {
      (this.element as HTMLElement).style.top = '-44px';
    } else {
      // Put whatever you need here if the filter bar is not present
    }
  }

  showNavbar() {
    (this.element as HTMLElement).style.top = '0';
  }
}
