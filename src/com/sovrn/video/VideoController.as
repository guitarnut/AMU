package com.sovrn.video {

    import com.sovrn.constants.AdVPAIDEvents;
    import com.sovrn.constants.Config;
    import com.sovrn.model.AdVO;
    import com.sovrn.utils.Console;
    import com.sovrn.view.Canvas;

    import flash.display.Sprite;
    import flash.events.Event;

    import vpaid.IVPAID;
    import vpaid.VPAIDEvent;

    public class VideoController extends Sprite implements IVPAID {

        private var video:VideoPlayer;
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
            video.resize(w, h, viewMode);
        }

        /* ------  control methods ----------------------------------------- */

        public function expandAd():void {
        }

        public function collapseAd():void {
        }

        public function startAd():void {
            video.play();
        }

        public function stopAd():void {
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