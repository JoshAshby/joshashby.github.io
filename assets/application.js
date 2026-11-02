function annotation(node) {
  node.addEventListener("click", e => {
    e.preventDefault()
    e.target.classList.toggle("-active")
  })
}

document.querySelectorAll(".annotation-trigger").forEach(annotation)

function toggleHidden(node) {
  const dataTarget = document.querySelector(node.dataset.target)
  const dataClass = node.dataset.toggledClass || "expand"

  node.addEventListener("click", e => {
    node.dataset.toggledState = dataTarget.classList.toggle(dataClass)
  })
}

document.querySelectorAll("[data-behavior~=toggle-hidden]").forEach(toggleHidden)
