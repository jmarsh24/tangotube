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

    const filterBar = document.getElementById('filter-bar');

    if (scrollTop > this.lastScrollTop) {
      this.hideNavbar(filterBar);
    } else {
      this.showNavbar();
    }
    this.lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
  }

  hideNavbar(filterBar: HTMLElement | null) {
    if (filterBar) {
      (this.element as HTMLElement).style.top = '-56px';
    } else {
    }
  }

  showNavbar() {
    (this.element as HTMLElement).style.top = '0';
  }
}
