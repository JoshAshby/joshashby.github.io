//import "@tailwindcss/browser"
import "@tailwindplus/elements"

import "@hotwired/turbo"
import { Application } from "@hotwired/stimulus"

import RemoveAfterAnimationController from "controllers/remove-after-animation-controller.js"
import SelectAllController from "controllers/select-all-controller.js"
import StickyStuckController from "controllers/sticky-stuck-controller.js"
import SubmitOnChangeController from "controllers/submit-on-change-controller.js"
import Removable from "controllers/removable.js"

window.Stimulus = Application.start()
Stimulus.register("remove-after-animation", RemoveAfterAnimationController)
Stimulus.register("select-all", SelectAllController)
Stimulus.register("sticky-stuck", StickyStuckController)
Stimulus.register("submit-on-change", SubmitOnChangeController)
Stimulus.register("removable", Removable)
