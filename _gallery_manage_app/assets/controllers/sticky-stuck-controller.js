import { Controller } from "@hotwired/stimulus"

/**
 * Adds a "data-sticky-stuck" attribute to the element if it is currently "stuck"
 * from "position: sticky;" usage.
 *
 * **REQUIRES** the use of a "top: -1px;" too!
 *
 * @see https://stackoverflow.com/a/74812383/3877528
 */
export default class extends Controller {
  #observer = null

  connect() {
    this.#observer = new IntersectionObserver(
      ([e]) => e.target.dataset.stickyStuck = e.intersectionRatio < 1,
      { threshold: [1] }
    )

    this.#observer.observe(this.element)
  }

  disconnect() {
    this.#observer.unobserve(this.element)
    this.#observer = null
  }
}

