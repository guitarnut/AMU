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

    import vpaid.IVPAID;
    import vpaid.VPAIDEvent;

    public class VideoController extends Sprite implements IVPAID {

        private var video:VideoPlayer;
        private var muteButton:MuteButton;
        private var playButton:PlayButton;
        private var text:TextMessage;
        private var _view:Canvas;
        private var _data:AdVO;
        private var _mediaFileVOs:Array;

        public function VideoController() {
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
            dispatchEvent(new VPAIDEvent(e.type));

            switch(e.type) {
                case VPAIDEvent.AdRemainingTimeChange:
                    updateTime(video.currentTime);
                    break;
            }
        }

        private function positionAssets():void {
            text.x = 3;
            text.y = 3;

            muteButton.x = 3;
            muteButton.y = 1;
            muteButton.width = 30;
            muteButton.height = 25;

            playButton.x = _view.width / 2 - playButton.width / 2;
            playButton.y = _view.height / 2 - playButton.height / 2;
        }

        private function updateTime(time:Number):void {
            if(text) {
                text.x = _view.width - 15;
                text.show();
                text.update(String(time));
            }
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

            addEvents();

            video.init();
            _view.addChild(video);

            text = new TextMessage();
            text.update("Advertisement");
            text.show();
            _view.addChild(text);

            muteButton = new MuteButton();

            playButton = new PlayButton();
            _view.addChild(playButton);

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
            return -2;
        }

        public function get adVolume():Number {
            return 0;
        }

        public function set adVolume(val:Number):void {
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
            _view.removeChild(playButton);
            _view.addChild(muteButton);
            text.hide();
            video.play();
        }

        public function stopAd():void {
            video.stop();
        }

        public function pauseAd():void {
            video.pause();
        }

        public function resumeAd():void {
            video.resume();
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
            return -2;
        }

        public function get adCompanions():String {
            return " ";
        }
    }
}