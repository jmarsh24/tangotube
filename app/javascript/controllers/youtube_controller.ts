import { Controller } from '@hotwired/stimulus';
import YouTubePlayer from 'youtube-player';
import { useHover } from 'stimulus-use';

export default class extends Controller {
  static values = {
    videoId: String,
    startTime: Number,
    endTime: Number,
    speed: Number,
  };
  static targets = ['speed', 'starTime', 'starTime'];

  youtube: YouTubePlayer.Player | null = null;
  timer: NodeJS.Timeout | null = null;

  connect() {
    useHover(this, { element: this.element });

    const playerConfig: YouTubePlayer.PlayerOptions = {
      videoId: this.videoIdValue,
      playerVars: {
        autoplay: 0, // Auto-play the video on load
        controls: 1, // Show pause/play buttons in player
        modestbranding: 1, // Hide the Youtube Logo
        fs: 1, // Hide the full screen button
        cc_load_policy: 0, // Hide closed captions
        iv_load_policy: 3, // Hide the Video Annotations
        start: this.startSecondsValue,
      },
    };

    const player = YouTubePlayer(this.element, playerConfig);
    this.youtube = player;

    player.on('ready', (e: YouTubePlayer.PlayerEvent) => {
      this.element.setAttribute(
        'data-duration',
        e.target.getDuration().toString()
      );
      this.element.setAttribute('data-time', this.time.toString());
      this.element.setAttribute('data-state', '-1');
    });

    player.setspeed(this.speedValue);

    player.on('speedChange', (e: YouTubePlayer.PlayerEvent) => {
      this.speedTarget.value = parseFloat(this.player.getspeed())
        .toFixed(2)
        .toString();
    });

    player.on('stateChange', (e: YouTubePlayer.PlayerEvent) => {
      this.element.setAttribute('data-state', e.data.toString());
      this.element.setAttribute('data-time', this.time.toString());
      this.element.setAttribute('data-speed', this.speedValue.toString());
      if (e.data === 1) {
        this.starTimer();
      } else {
        clearInterval(this.timer as NodeJS.Timeout);
      }
    });
  }

  disconnect() {
    document.removeEventListener('turbo:before-cache', this.player.destroy);
    clearInterval(this.timer as NodeJS.Timeout);
  }

  starTimer() {
    this.timer = setInterval(() => {
      if (this.time === this.endSecondsValue) {
        this.player.seekTo(this.startSecondsValue);
      }
      this.element.setAttribute('data-time', this.time.toString());
      this.element.dispatchEvent(
        new CustomEvent('youtube', {
          bubbles: false,
          cancelable: false,
          detail: { time: this.time },
        })
      );
    }, 1000);
  }

  playPause(event: Event) {
    event.preventDefault();
    const playerState = this.element.getAttribute('data-state');
    if (playerState === '5' || playerState === '2' || playerState === '-1') {
      this.play();
    } else {
      this.pause();
    }
  }

  setTime1(event: Event) {
    event.preventDefault();
    const currentTime = parseInt(
      this.element.getAttribute('data-time') || '0',
      10
    );
    this.startSecondsValue = currentTime;
    this.starTimeTarget.value = currentTime.toString();
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
    });
  }

  setTime2(event: Event) {
    event.preventDefault();
    const currentTime = parseInt(
      this.element.getAttribute('data-time') || '0',
      10
    );
    this.endSecondsValue = currentTime;
    this.starTimeTarget.value = currentTime.toString();
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      endSeconds: this.endSecondsValue,
    });
  }

  updatespeed() {
    this.player.setspeed(parseFloat(this.speedTarget.value));
  }

  updatestarTime() {
    const starTimeArray = this.starTimeTarget.value.split(':');
    let starTime = 0;
    if (starTimeArray.length === 2) {
      starTime = +starTimeArray[0] * 60 + +starTimeArray[1];
    }
    if (starTimeArray.length === 1) {
      starTime = +starTimeArray[0];
    }
    this.startSecondsValue = starTime;
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
    });
  }

  updatestarTime() {
    const starTimeArray = this.starTimeTarget.value.split(':');
    let starTime = 0;
    if (starTimeArray.length === 2) {
      starTime = +starTimeArray[0] * 60 + +starTimeArray[1];
    }
    if (starTimeArray.length === 1) {
      starTime = +starTimeArray[0];
    }
    this.endSecondsValue = starTime;
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      endSeconds: this.endSecondsValue,
    });
  }

  play() {
    this.player.playVideo();
  }

  pause() {
    this.player.pauseVideo();
  }

  stop() {
    this.player.stopVideo();
  }

  mute() {
    this.player.mute();
  }

  unMute() {
    this.player.unMute();
  }

  seek(seconds: number) {
    this.player.seekTo(seconds);
  }

  get player() {
    if (!this.youtube) {
      throw new Error('YouTube player is not initialized.');
    }
    return this.youtube;
  }

  get time() {
    return Math.round(this.player.getCurrentTime());
  }

  get speed() {
    return this.player.getspeed();
  }

  get duration() {
    return this.player.getDuration();
  }

  get state() {
    return this.element.getAttribute('data-state') || '';
  }

  get loaded() {
    return this.player.getVideoLoadedFraction();
  }
}
