import { Application } from "@hotwired/stimulus";
import Hotkeys from "stimulus-hotkeys";

const application = Application.start();

application.register("hotkeys", Hotkeys);

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
