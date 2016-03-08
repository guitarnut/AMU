package com.sovrn.model {

    public class MediaFileVO {

        private var _mediaFile:String;
        private var _width:Number;
        private var _height:Number;
        private var _delivery:String;
        private var _type:String;
        private var _apiFramework:String;
        private var _bitrate:Number;

        public function MediaFileVO() {
        }

        public function set mediaFile(val:String):void {
            if (!_mediaFile) _mediaFile = val;
        }

        public function get mediaFile():String {
            return _mediaFile;
        }

        public function set width(val:Number):void {
            if (!_width) _width = val;
        }

        public function get width():Number {
            return _width;
        }

        public function set height(val:Number):void {
            if (!_height) _height = val;
        }

        public function get height():Number {
            return _height;
        }

        public function set delivery(val:String):void {
            if (!_delivery) _delivery = val;
        }

        public function get delivery():String {
            return _delivery;
        }

        public function set type(val:String):void {
            if (!_type) _type = val;
        }

        public function get type():String {
            return _type;
        }

        public function set apiFramework(val:String):void {
            if (!_apiFramework) _apiFramework = val;
        }

        public function get apiFramework():String {
            return _apiFramework;
        }

        public function set bitrate(val:Number):void {
            if (!_bitrate) _bitrate = val;
        }

        public function get bitrate():Number {
            return _bitrate;
        }

    }

}