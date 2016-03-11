package com.sovrn.vpaid {

    public class VPAIDState {

        private static var _init_ad_called:Boolean;
        private static var _ad_loaded_fired:Boolean;
        private static var _ad_started_fired:Boolean;
        private static var _ad_impression_fired:Boolean;
        private static var _ad_stopped_fired:Boolean;
        private static var _ad_error_fired:Boolean;
        private static var _ad_volume:Number;
        private static var _fired_events:Array;

        public static function reset():void {
            _init_ad_called = false;
            _ad_loaded_fired = false;
            _ad_started_fired = false;
            _ad_impression_fired = false;
            _ad_stopped_fired = false;
            _ad_error_fired = false;
            _ad_volume = 0;
            _fired_events = [];
        }

        public static function eventFired(e:String):Boolean {
            if(_fired_events.indexOf(e) == -1) {
                _fired_events.push(e);
                return false;
            } else {
                return true;
            }
        }

        public static function initAd():void {
            _init_ad_called = true;
        }

        public static function get initAdCalled():Boolean {
            return _init_ad_called;
        }

        public static function AdLoaded():void {
            _ad_loaded_fired = true;
        }

        public static function get AdLoadedFired():Boolean {
            return _init_ad_called;
        }

        public static function AdStarted():void {
            _ad_started_fired = true;
        }

        public static function get AdStartedFired():Boolean {
            return _init_ad_called;
        }

        public static function AdImpression():void {
            _ad_impression_fired = true;
        }

        public static function get AdImpressionFired():Boolean {
            return _init_ad_called;
        }

        public static function AdStopped():void {
            _ad_stopped_fired = true;
        }

        public static function get AdStoppedFired():Boolean {
            return _ad_stopped_fired;
        }

        public static function AdError():void {
            _ad_error_fired = true;
        }

        public static function get AdErrorFired():Boolean {
            return _ad_error_fired;
        }

        public static function set volume(val:Number):void {
            _ad_volume = val;
        }

        public static function get volume():Number {
            return _ad_volume;
        }


    }

}