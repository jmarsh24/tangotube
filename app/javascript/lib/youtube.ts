export function loadYouTubePlayerAPI() {
  // Load the YouTube IFrame Player API code asynchronously.
  const tag = document.createElement('script');
  tag.src = 'https://www.youtube.com/player_api';

  // Ensure that the script element has a parentNode before attempting to insert it
  const firstScriptTag = document.querySelector('script');
  if (firstScriptTag?.parentNode) {
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  }
}
