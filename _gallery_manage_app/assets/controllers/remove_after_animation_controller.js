import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    Promise.all(
      this.element.getAnimations({ subtree: true })
        .map((animation) => animation.finished),
    ).then(() => this.element.remove());
  }
}
