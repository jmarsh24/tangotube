import '~/controllers';
import '../../frontend/styles/application.scss';
import '@hotwired/turbo-rails';

import * as ActiveStorage from '@rails/activestorage';
ActiveStorage.start();

console.log('Vite ⚡️ Rails');

import { start } from '@nerdgeschoss/shimmer';
import { application } from '../controllers/application';
import { startErrorTracking } from '../lib/error-tracking';

// Load the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = 'https://www.youtube.com/player_api';
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

startErrorTracking();
start({ application });
