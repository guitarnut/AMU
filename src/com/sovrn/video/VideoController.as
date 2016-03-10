package com.sovrn.video {

    import com.sovrn.constants.AdVPAIDEvents;
    import com.sovrn.constants.Config;
    import com.sovrn.model.AdVO;
    import com.sovrn.utils.Console;
    import com.sovrn.video.view.MuteButton;
    import com.sovrn.video.view.PlayButton;
    import com.sovrn.video.view.TextMessage;
    import com.sovrn.view.Canvas;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import vpaid.IVPAID;
    import vpaid.VPAIDEvent;

    public class VideoController extends Sprite implements IVPAID {

        private var video:VideoPlayer;
        private var muteButton:MuteButton;
        private var playButton:PlayButton;
        private var text:TextMessage;
        private var volume:Number = 1;
        private var videoStarted:Boolean;
        private var _view:Canvas;
        private var _data:AdVO;
        private var _mediaFileVOs:Array;

        public function VideoController() {
            text = new TextMessage();

            muteButton = new MuteButton();
            muteButton.addEventListener(MouseEvent.CLICK, handleMuteClick);
            muteButton.volume(volume);

            playButton = new PlayButton();
            playButton.addEventListener(MouseEvent.CLICK, handlePlayClick);
        }

        public function set view(val:Canvas):void {
            _view = val;
        }

        public function set config(val:AdVO):void {
            _data = val;
            _mediaFileVOs = _data.mediaFileData;
        }

        private function addEvents():void {
            AdVPAIDEvents.ALL_EVENTS.map(function (val:String, index:Number, array:Array):void {
                video.addEventListener(val, handleEvents);
            });
        }

        private function removeEvents():void {
            AdVPAIDEvents.ALL_EVENTS.map(function (val:String, index:Number, array:Array):void {
                video.removeEventListener(val, handleEvents);
            });
        }

        private function handleEvents(e:Event):void {
            switch (e.type) {
                case VPAIDEvent.AdRemainingTimeChange:
                    updateTime(video.duration - video.currentTime);
                    break;
                case VPAIDEvent.AdError:
                    removeEvents();
                    break;
            }

            dispatchEvent(new VPAIDEvent(e.type));
        }

        private function positionAssets():void {
            text.x = 3;
            text.y = 3;

            muteButton.x = 3;
            muteButton.y = 1;
            muteButton.width = 30;
            muteButton.height = 25;

            centerPlayButton();
        }

        private function centerPlayButton():void {
            playButton.x = _view.width / 2 - playButton.width / 2;
            playButton.y = _view.height / 2 - playButton.height / 2;
        }

        private function updateTime(time:Number):void {
            if (text) {
                text.show();
                text.update(formatTime(time));
                text.x = _view.width - text.width - 5;
            }
        }

        private function formatTime(time:Number):String {
            var seconds:String = String(time % 60);
            var minutes:String = String(Math.floor(time / 60));
            if (seconds.length == 1) seconds = "0" + seconds;
            return minutes + ":" + seconds;
        }

        private function handleMuteClick(e:MouseEvent):void {
            e.stopImmediatePropagation();

            if (muteButton.isMuted) {
                video.volume = 0;
            } else {
                video.volume = volume;
            }
        }

        private function handlePlayClick(e:MouseEvent):void {
            e.stopImmediatePropagation();

            if(!videoStarted) {
                startAd();
            } else {
                resumeAd();
            }
        }

        private function videoClicked(e:Event):void {
            e.stopImmediatePropagation();
            pauseAd();
        }

        private function adStarted(e:Event):void {
            muteButton.show();
            text.hide();
        }

        /* ----------------------------------------- */
        // IVPAID methods
        /* ----------------------------------------- */

        public function handshakeVersion(playerVPAIDVersion:String):String {
            return Config.VPAID_VERSION;
        }

        public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String = "", environmentVars:String = ""):void {
            video = new VideoPlayer(width, height, _mediaFileVOs);
            video.bitrate = desiredBitrate;
            video.clickThrough = _data.clickThrough;
            video.clickTracking = _data.clickTracking;
            video.view = _view;
            video.volume = volume;
            video.addEventListener(MouseEvent.CLICK, videoClicked);
            video.addEventListener(VPAIDEvent.AdStarted, adStarted);

            addEvents();

            video.init();

            text.update("Advertisement");
            text.show();

            _view.addChild(video);
            _view.addChild(text);
            _view.addChild(muteButton);
            _view.addChild(playButton);

            muteButton.hide();

            positionAssets();
        }

        /* ------ getters / setters ----------------------------------------- */

        public function get adLinear():Boolean {
            return true;
        }

        public function get adExpanded():Boolean {
            return false;
        }

        public function get adRemainingTime():Number {
            return video.duration - video.currentTime || -2;
        }

        public function get adVolume():Number {
            return video.volume;
        }

        public function set adVolume(val:Number):void {
            if (muteButton) muteButton.volume(val);
            if (video) video.volume = val;
            volume = val;
        }

        /* ------ layout methods ----------------------------------------- */

        public function resizeAd(w:Number, h:Number, viewMode:String):void {
            _view.resize(w, h);
            video.resize(w, h, viewMode);
            positionAssets();
        }

        /* ------  control methods ----------------------------------------- */

        public function expandAd():void {
        }

        public function collapseAd():void {
        }

        public function startAd():void {
            videoStarted = true;
            playButton.hide();
            muteButton.show();
            text.hide();
            video.play();
        }

        public function stopAd():void {
            _view.cleanup();
            video.stop();
        }

        public function pauseAd():void {
            video.pause();
            centerPlayButton();
            playButton.show();
        }

        public function resumeAd():void {
            video.resume();
            playButton.hide();
        }

        /* --------------------------- */
        /* ------  VPAID 2.0 methods ----------------------------------------- */
        /* --------------------------- */

        public function skipAd():void {
        }

        public function get adWidth():Number {
            return 0;
        }

        public function get adHeight():Number {
            return 0;
        }

        public function get adIcons():Boolean {
            return false;
        }

        public function get adSkippableState():Boolean {
            return false;
        }

        public function get adDuration():Number {
            return video.duration || -2;
        }

        public function get adCompanions():String {
            return " ";
        }
    }
}