// Entry point for the build script in your package.json
require("@hotwired/turbo")

import "./controllers"
import "@fortawesome/fontawesome-free/js/all"

// Load the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);


