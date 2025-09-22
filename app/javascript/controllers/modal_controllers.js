import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close(event) {
    event.preventDefault()
    const el = document.getElementById("modal")
    if (el) el.innerHTML = ""
  }
}