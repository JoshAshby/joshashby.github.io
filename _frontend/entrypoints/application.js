// To see this message, follow the instructions for your Ruby framework.
//
// When using a plain API, perhaps it's better to generate an HTML entrypoint
// and link to the scripts and stylesheets, and let Vite transform it.
//console.log('Vite ⚡️ Ruby')

// Example: Import a stylesheet in <sourceCodeDir>/index.css
// import '~/index.css'
//import "~/css/default.css"
//import "~/css/jashby.css"
//import "~/css/syntax.css"

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
