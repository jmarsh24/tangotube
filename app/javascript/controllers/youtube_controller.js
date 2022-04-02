import { Controller } from "@hotwired/stimulus";
import YouTubePlayer from "youtube-player";
import { useHover } from "stimulus-use";

export default class extends Controller {
  static values = {
    videoId: String,
    startSeconds: Number,
    endSeconds: Number,
    playbackRate: Number,
  };
  static targets = ["frame", "playbackRate", "startTime", "endTime"];

  connect() {
    useHover(this, { element: this.element });
    var playerConfig = {
      videoId: this.videoIdValue,
      playerVars: {
        autoplay: 0, // Auto-play the video on load
        controls: 1, // Show pause/play buttons in player
        modestbranding: 1, // Hide the Youtube Logo
        fs: 1, // Hide the full screen button
        cc_load_policy: 0, // Hide closed captions
        iv_load_policy: 3, // Hide the Video Annotations
        start: this.startSecondsValue,
        // end: this.endSecondsValue,
      },
    };

    const player = YouTubePlayer(this.frameTarget, playerConfig);

    player.on("ready", (e) => {
      this.element.setAttribute("data-duration", e.target.getDuration());
      this.youtube = e.target;
      this.element.setAttribute("data-time", this.time);
      this.element.setAttribute("data-state", -1);
    });

    player.setPlaybackRate(this.playbackRateValue);

    player.on("playbackRateChange", (e) => {
      this.playbackRateTarget.value = parseFloat(this.player.getPlaybackRate())
        .toFixed(2)
        .toString();
    });

    player.on("stateChange", (e) => {
      this.element.setAttribute("data-state", e.data);
      this.element.setAttribute("data-time", this.time);
      this.element.setAttribute("data-playbackRate", this.playbackRateValue);
      e.data === 1 ? this.startTimer() : clearInterval(this.timer);
    });
  }

  // mouseEnter() {
  //   this.play();
  // }

  // mouseLeave() {
  //   this.pause();
  // }

  updatePlaybackRate() {
    this.player.setPlaybackRate(parseFloat(this.playbackRateTarget.value));
  }

  updateStartTime() {
    var startTimeArray = this.startTimeTarget.value.split(":");
    if (startTimeArray.length == 2) {
      var startTime = +startTimeArray[0] * 60 + +startTimeArray[1];
    }
    if (startTimeArray.length == 1) {
      var startTime = startTimeArray[0];
    }
    this.startSecondsValue = startTime;
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      // endSeconds: this.endSecondsValue,
    });
  }

  updateEndTime() {
    var endTimeArray = this.endTimeTarget.value.split(":");
    if (endTimeArray.length == 2) {
      var endTime = +endTimeArray[0] * 60 + +endTimeArray[1];
    }
    if (endTimeArray.length == 1) {
      var endTime = endTimeArray[0];
    }
    this.endSecondsValue = endTime;
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      // endSeconds: this.endSecondsValue,
    });
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.player.destroy);
  }

  startTimer() {
    this.timer = setInterval(() => {
      if (this.time == this.endSecondsValue) {
        this.player.seekTo(this.startSecondsValue);
      }
      this.element.setAttribute("data-time", this.time);
      this.element.dispatchEvent(
        new CustomEvent("youtube", {
          bubbles: false,
          cancelable: false,
          detail: { time: this.time },
        })
      );
    }, 1000);
  }

  playPause(event) {
    event.preventDefault();
    var playerState = this.element.getAttribute("data-state");
    if (playerState == 5 || playerState == 2 || playerState == -1) {
      this.play();
    } else {
      this.pause();
    }
  }

  setTime1(event) {
    event.preventDefault();
    var currentTime = this.element.getAttribute("data-time");
    this.startSecondsValue = currentTime;
    this.startTimeTarget.value = currentTime;
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      endSeconds: this.endSecondsValue,
    });
  }

  setTime2(event) {
    event.preventDefault();
    var currentTime = this.element.getAttribute("data-time");
    this.endSecondsValue = currentTime;
    this.endTimeTarget.value = currentTime;
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      endSeconds: this.endSecondsValue,
    });
  }

  toggleMute(event) {
    event.preventDefault();
    if (this.player.isMuted()) {
      this.unMute();
    } else {
      this.mute();
    }
  }

  reset(event) {
    event.preventDefault();
    var currentTime = this.time;
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: currentTime,
    });
    this.endSecondsValue = "";
    this.endTimeTarget.value = "";
    this.startSecondsValue = "";
    this.startTimeTarget.value = "";
    this.player.setPlaybackRate(1);
    this.playbackRateTarget == 1;
  }

  playFullscreen() {
    this.play(); //won't work on mobile
    var iframe = this.frameTarget;
    var requestFullScreen =
      iframe.requestFullScreen ||
      iframe.mozRequestFullScreen ||
      iframe.webkitRequestFullScreen;
    if (requestFullScreen) {
      requestFullScreen.bind(iframe)();
    }
  }

  increasePlaybackRate(event) {
    event.preventDefault();
    this.player.setPlaybackRate(this.playbackRate + 0.25);
  }

  decreasePlaybackRate(event) {
    event.preventDefault();
    this.player.setPlaybackRate(this.playbackRate - 0.25);
  }

  seekForward(event) {
    event.preventDefault();
    this.seek(this.time + 5);
  }

  seekBackward(event) {
    event.preventDefault();
    this.seek(this.time - 5);
  }

  play = () => this.player.playVideo();
  pause = () => this.player.pauseVideo();
  stop = () => this.player.stopVideo();
  mute = () => this.player.mute();
  unMute = () => this.player.unMute();
  seek = (seconds) => this.player.seekTo(seconds);
  // playbackRate = (rate) => this.player.setPlaybackRate(rate);

  get player() {
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
    return this.element.getAttribute("data-state");
  }
  get loaded() {
    return this.player.getVideoLoadedFraction();
  }
}
