// app/javascript/controllers/recent_search_controller.ts
import { Controller } from '@hotwired/stimulus';
// @ts-ignore
import { FetchRequest } from '@rails/request.js';

export default class extends Controller {
  static values = { gid: String, query: String, category: String };
  gidValue!: string;
  queryValue!: string;
  categoryValue!: string;

  async handleClick() {
    const url = '/recent_searches';

    const params = {
      recent_search: {
        resource_gid: this.gidValue,
        query: this.queryValue,
        category: this.categoryValue,
      },
    };

    const request = new FetchRequest('POST', url, {
      body: JSON.stringify(params),
      headers: { 'Content-Type': 'application/json' },
    });

    const response = await request.perform();
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
  }
}
