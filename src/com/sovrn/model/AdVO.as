package com.sovrn.model {

    public class AdVO {

        private var _adType:String;
        private var _slot:int;
        private var _VASTVersion:String;
        private var _adSystem:Array;
        private var _adTitle:Array;
        private var _sovrnImpression:String;
        private var _impressions:Array;
        private var _errors:Array;
        private var _clickThrough:String;
        private var _clickTracking:Array;
        private var _trackingEvents:Object;
        private var _duration:String;
        private var _adParameters:String;
        private var _mediaFiles:Array;
        private var _tid:String;
        private var _campaignId:int;
        private var _cb:String;
        private var _bannerId:int;
        private var _rtb_tid:String;
        private var _rpid:int;

        public function AdVO() {
        }

        public function set adType(val:String):void {
            if(!_adType) _adType = val;
        }

        public function get adType():String {
            return _adType;
        }

        public function set slot(val:int):void {
            if(!_slot) _slot = val;
        }

        public function get slot():int {
            return _slot;
        }

        public function set VASTVersion(val:String):void {
            if(!_VASTVersion) _VASTVersion = val;
        }

        public function get VASTVersion():String {
            return _VASTVersion;
        }

        public function set adSystem(val:Array):void {
            if(!_adSystem) _adSystem = val;
        }

        public function get adSystem():Array {
            return _adSystem;
        }

        public function set adTitle(val:Array):void {
            if(!_adTitle) _adTitle = val;
        }

        public function get adTitle():Array {
            return _adTitle;
        }

        public function set sovrnImpression(val:String):void {
            if(!_sovrnImpression) _sovrnImpression = val;
        }

        public function get sovrnImpression():String {
            return _sovrnImpression;
        }

        public function set impressions(val:Array):void {
            if(!_impressions) _impressions = val;
        }

        public function get impressions():Array {
            return _impressions;
        }

        public function set errors(val:Array):void {
            if(!_errors) _errors = val;
        }

        public function get errors():Array {
            return _errors;
        }

        public function set clickThrough(val:String):void {
            if(!_clickThrough) _clickThrough = val;
        }

        public function get clickThrough():String {
            return _clickThrough;
        }

        public function set clickTracking(val:Array):void {
            if(!_clickTracking) _clickTracking = val;
        }

        public function get clickTracking():Array {
            return _clickTracking;
        }

        public function set trackingEvents(val:Object):void {
            if(!_trackingEvents) _trackingEvents = val;
        }

        public function get trackingEvents():Object {
            return _trackingEvents;
        }

        public function set duration(val:String):void {
            if(!_duration) _duration = val;
        }

        public function get duration():String {
            return _duration;
        }

        public function set adParameters(val:String):void {
            if(!_adParameters) _adParameters = val;
        }

        public function get adParameters():String {
            return _adParameters;
        }

        public function set mediaFiles(val:Array):void {
            if(!_mediaFiles) _mediaFiles = val;
        }

        public function get mediaFiles():Array {
            return _mediaFiles;
        }

        public function set tid(val:String):void {
            if(!_tid) _tid = val;
        }

        public function get tid():String {
            return _tid;
        }

        public function set campaignId(val:int):void {
            if(!_campaignId) _campaignId = val;
        }

        public function get campaignId():int {
            return _campaignId;
        }

        public function set cb(val:String):void {
            if(!_cb) _cb = val;
        }

        public function get cb():String {
            return _cb;
        }

        public function set bannerId(val:int):void {
            if(!_bannerId) _bannerId = val;
        }

        public function get bannerId():int {
            return _bannerId;
        }

        public function set rtb_tid(val:String):void {
            if(!_rtb_tid) _rtb_tid = val;
        }

        public function get rtb_tid():String {
            return _rtb_tid;
        }

        public function set rpid(val:int):void {
            if(!_rpid) _rpid = val;
        }

        public function get rpid():int {
            return _rpid;
        }
    }

}