// Entry point for the build script in your package.json
import "@fortawesome/fontawesome-free/js/all"

import "./channels"
import "./controllers"

import { Turbo } from "@hotwired/turbo-rails"

// Load the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
