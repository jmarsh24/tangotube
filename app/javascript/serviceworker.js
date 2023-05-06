var CACHE_VERSION = 'v1'
var CACHE_NAME = CACHE_VERSION + ':sw-cache-'
var CACHE_FILES = ['/offline.html']

function onInstall (event) {
  console.debug('[Serviceworker]', 'Installing!', event)
  event.waitUntil(
    caches
      .open(CACHE_NAME)
      .then(function prefill (cache) {
        console.debug('caching', CACHE_FILES)
        return cache.addAll(CACHE_FILES)
      })
      .then(self.skipWaiting)
  )
}

// Borrowed from https://github.com/TalAter/UpUp
function onFetch (event) {
  event.respondWith(
    // try to return untouched request from network first
    fetch(event.request).catch(function () {
      // if it fails, try to return request from the cache
      return caches.match(event.request).then(function (response) {
        if (response) {
          return response
        }
        // if not found in cache, return default offline content for navigate requests
        if (
          event.request.mode === 'navigate' ||
          (event.request.method === 'GET' &&
            event.request.headers.get('accept').includes('text/html'))
        ) {
          console.log('[Serviceworker]', 'Fetching offline content', event)
          return caches.match('/offline.html')
        }
      })
    })
  )
}

self.addEventListener('install', onInstall)
self.addEventListener('activate', onActivate)
self.addEventListener('fetch', onFetch)
