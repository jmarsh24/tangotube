import { Controller } from '@hotwired/stimulus';
import YouTubePlayer from 'youtube-player';
import { useHover } from 'stimulus-use';

export default class extends Controller {
  static values = {
    videoId: String,
    startSeconds: Number,
    endSeconds: Number,
    playbackRate: Number,
  };
  static targets = ['frame', 'playbackRate', 'startTime', 'endTime'];

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

    const player = YouTubePlayer(this.frameTarget, playerConfig);
    this.youtube = player;

    player.on('ready', (e: YouTubePlayer.PlayerEvent) => {
      this.element.setAttribute(
        'data-duration',
        e.target.getDuration().toString()
      );
      this.element.setAttribute('data-time', this.time.toString());
      this.element.setAttribute('data-state', '-1');
    });

    player.setPlaybackRate(this.playbackRateValue);

    player.on('playbackRateChange', (e: YouTubePlayer.PlayerEvent) => {
      this.playbackRateTarget.value = parseFloat(this.player.getPlaybackRate())
        .toFixed(2)
        .toString();
    });

    player.on('stateChange', (e: YouTubePlayer.PlayerEvent) => {
      this.element.setAttribute('data-state', e.data.toString());
      this.element.setAttribute('data-time', this.time.toString());
      this.element.setAttribute(
        'data-playbackRate',
        this.playbackRateValue.toString()
      );
      if (e.data === 1) {
        this.startTimer();
      } else {
        clearInterval(this.timer as NodeJS.Timeout);
      }
    });
  }

  disconnect() {
    document.removeEventListener('turbo:before-cache', this.player.destroy);
    clearInterval(this.timer as NodeJS.Timeout);
  }

  startTimer() {
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
    this.startTimeTarget.value = currentTime.toString();
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
    this.endTimeTarget.value = currentTime.toString();
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      endSeconds: this.endSecondsValue,
    });
  }

  updatePlaybackRate() {
    this.player.setPlaybackRate(parseFloat(this.playbackRateTarget.value));
  }

  updateStartTime() {
    const startTimeArray = this.startTimeTarget.value.split(':');
    let startTime = 0;
    if (startTimeArray.length === 2) {
      startTime = +startTimeArray[0] * 60 + +startTimeArray[1];
    }
    if (startTimeArray.length === 1) {
      startTime = +startTimeArray[0];
    }
    this.startSecondsValue = startTime;
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
    });
  }

  updateEndTime() {
    const endTimeArray = this.endTimeTarget.value.split(':');
    let endTime = 0;
    if (endTimeArray.length === 2) {
      endTime = +endTimeArray[0] * 60 + +endTimeArray[1];
    }
    if (endTimeArray.length === 1) {
      endTime = +endTimeArray[0];
    }
    this.endSecondsValue = endTime;
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

  get playbackRate() {
    return this.player.getPlaybackRate();
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
