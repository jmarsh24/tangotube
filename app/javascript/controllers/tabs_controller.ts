import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['tab', 'tabPanel'];

  tabPanelTargets!: HTMLElement[];
  tabTargets!: HTMLElement[];

  initialize(): void {
    this.showTab();
  }

  change(event: Event): void {
    const currentTarget = event.currentTarget as HTMLElement;
    this.index = this.tabTargets.indexOf(currentTarget);
    this.showTab();
  }

  showTab(): void {
    this.tabPanelTargets.forEach((el, i) => {
      if (i === this.index) {
        el.classList.remove('hidden');
      } else {
        el.classList.add('hidden');
      }
    });

    this.tabTargets.forEach((el, i) => {
      if (i === this.index) {
        el.classList.add('active');
      } else {
        el.classList.remove('active');
      }
    });
  }

  get index(): number {
    const index = this.data.get('index');
    return index ? parseInt(index) : 0;
  }

  set index(value: number) {
    this.data.set('index', value.toString());
    this.showTab();
  }
}
