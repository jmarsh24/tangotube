import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  tabPanelTargets!: HTMLElement[];
  tabTargets!: HTMLElement[];

  static targets = ['tab', 'tabPanel'];

  initialize() {
    this.showTab();
  }

  change(e) {
    this.index = this.tabTargets.indexOf(e.target);
    this.showTab(this.index);
  }

  showTab() {
    this.tabPanelTargets.forEach((el, i) => {
      if (i == this.index) {
        el.classList.remove('hidden');
      } else {
        el.classList.add('hidden');
      }
    });

    this.tabTargets.forEach((el, i) => {
      if (i == this.index) {
        el.classList.add('active');
      } else {
        el.classList.remove('active');
      }
    });
  }

  get index() {
    return parseInt(this.data.get('index'));
  }

  set index(value): number {
    this.data.set('index', value);
    this.showTab();
  }
}
