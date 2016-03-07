package com.sovrn.video {

    import com.sovrn.constants.Config;

    import vpaid.IVPAID;

    public class VideoController implements IVPAID {

        public function VideoController() {

        }

        /* ----------------------------------------- */
        // IVPAID methods
        /* ----------------------------------------- */

        public function handshakeVersion(playerVPAIDVersion:String):String {
            return Config.VPAID_VERSION;
        }

        public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String = "", environmentVars:String = ""):void {

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
        }

        /* ------  control methods ----------------------------------------- */

        public function expandAd():void {
        }

        public function collapseAd():void {
        }

        public function startAd():void {
        }

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