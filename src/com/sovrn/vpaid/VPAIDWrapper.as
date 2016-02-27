package com.sovrn.vpaid {
    import com.sovrn.ads.AdController;
    import com.sovrn.events.AdManagerEvent;

    import flash.display.Sprite;

    import vpaid.IVPAID;
    import vpaid.VPAIDEvent;

    public class VPAIDWrapper extends Sprite implements IVPAID {

        private const VPAID_VERSION:String = "2.0";
        private var adController:AdController;

        public function VPAIDWrapper(adController:AdController) {
            this.adController = adController;
        }

        private function handleAdControllerEvent(e:VPAIDEvent):void {
            switch(e.type) {
                case VPAIDEvent.AdError:
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError));
                    break;
                case VPAIDEvent.AdLoaded:
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLoaded));
                    break;
            }
        }

        public function handshakeVersion(playerVPAIDVersion:String):String {
            return VPAID_VERSION;
        }

        public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String = "", environmentVars:String = ""):void {
            dispatchEvent(new AdManagerEvent(AdManagerEvent.INIT_AD_CALLED, {
                width: width,
                height: height,
                viewMode: viewMode,
                bitrate: desiredBitrate,
                creativeData: creativeData,
                environmentVars: environmentVars
            }));
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

        public function set adVolume(value:Number):void {
        }

        /* ------ layout methods ----------------------------------------- */

        public function resizeAd(w:Number, h:Number, viewMode:String):void {
        }

        /* ------  control methods ----------------------------------------- */

        public function expandAd():void {
        }

        public function collapseAd():void {
        }

        public function startAd():void {
        }

        // this was called by the video player. we're done
        public function stopAd():void {
        }

        public function pauseAd():void {
        }

        public function resumeAd():void {
        }

        /* --------------------------- */
        /* ------  VPAID 2.0 methods ----------------------------------------- */
        /* --------------------------- */

        public function skipAd():void {
        }

        public function get adWidth():Number {
            return this.width;
        }

        public function get adHeight():Number {
            return this.height;
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
            return "";
        }

    }
}
