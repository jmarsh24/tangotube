require("@hotwired/turbo-rails");

import "@fortawesome/fontawesome-free/js/all";

import { setBasePath } from "@shoelace-style/shoelace/dist/utilities/base-path.js";
setBasePath("/shoelace-assets");

import "@shoelace-style/shoelace";

import "./channels";
import "./controllers";

// Load the IFrame Player API code asynchronously.
var tag = document.createElement("script");
tag.src = "https://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName("script")[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
