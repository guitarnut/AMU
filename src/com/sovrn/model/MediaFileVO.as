package com.sovrn.model {

    public class MediaFileVO {

        private var _width:Number;
        private var _height:Number;
        private var _delivery:String;
        private var _type:String;
        private var _apiFramework:String;

        public function MediaFileVO() {
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

        public function set delivery(val:String):void {
            _delivery = val;
        }

        public function get delivery():String {
            return _delivery;
        }

        public function set type(val:String):void {
            _type = val;
        }

        public function get type():String {
            return _type;
        }

        public function set apiFramework(val:String):void {
            _apiFramework = val;
        }

        public function get apiFramework():String {
            return _apiFramework;
        }

    }

}