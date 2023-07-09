export function loadYouTubePlayerAPI() {
  const tag = document.createElement('script');
  tag.src = 'https://www.youtube.com/player_api';

  const firstScriptTag = document.querySelector('script');
  if (firstScriptTag && firstScriptTag.parentNode) {
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  } else {
    document.head.appendChild(tag);
  }
}
