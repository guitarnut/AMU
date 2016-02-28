package com.sovrn.model {

    public class InitConfigVO {

        private var _width:Number;
        private var _height:Number;
        private var _viewMode:String;
        private var _bitrate:Number;
        private var _creativeData:String;
        private var _environmentVars:String;

        public function InitConfigVO() {
        }

        public function set width(val:Number):void {
            _width = val;
        }

        public function get width():Number {
            return _width;
        }

        public function set height(val:Number):void {
            _height = val;
        }

        public function get height():Number {
            return _height;
        }

        public function set viewMode(val:String):void {
            _viewMode = val;
        }

        public function get viewMode():String {
            return _viewMode;
        }

        public function set desiredBitrate(val:Number):void {
            _bitrate = val;
        }

        public function get desiredBitrate():Number {
            return _bitrate;
        }

        public function set creativeData(val:String):void {
            _creativeData = val;
        }

        public function get creativeData():String {
            return _creativeData;
        }

        public function set environmentVars(val:String):void {
            _environmentVars = val;
        }

        public function get environmentVars():String {
            return _environmentVars;
        }

    }

}