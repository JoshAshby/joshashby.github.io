//import "@tailwindcss/browser"
import "@tailwindplus/elements"

import "@hotwired/turbo"
import { Application } from "@hotwired/stimulus"

import HelloController from "controllers/hello_controller.js"
import RemoveAfterAnimationController from "controllers/remove_after_animation_controller.js"
import SelectAllController from "controllers/select-all-controller.js"

window.Stimulus = Application.start()
Stimulus.register("hello", HelloController)
Stimulus.register("remove-after-animation", RemoveAfterAnimationController)
Stimulus.register("select-all", SelectAllController)
