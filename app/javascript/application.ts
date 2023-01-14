import '@hotwired/turbo-rails';
import { start } from '@nerdgeschoss/shimmer';
import { application } from 'controllers/application';
import { startErrorTracking } from 'lib/error-tracking';
import './controllers';

import * as ActiveStorage from '@rails/activestorage';
ActiveStorage.start();

// Load the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = 'https://www.youtube.com/player_api';
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

startErrorTracking();

start({ application });
