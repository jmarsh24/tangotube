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
    let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    if (scrollTop > this.lastScrollTop) {
      // downscroll code
      this.hideNavbar();
    } else {
      // upscroll code
      this.showNavbar();
    }
    this.lastScrollTop = scrollTop <= 0 ? 0 : scrollTop; // For Mobile or negative scrolling
  }

  hideNavbar() {
    // Use the actual height of your navbar
    // this.element refers to the element this controller is connected to
    (this.element as HTMLElement).style.top = '-52px';
  }

  showNavbar() {
    (this.element as HTMLElement).style.top = '0';
  }
}
