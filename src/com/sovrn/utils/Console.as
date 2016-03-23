package com.sovrn.utils {

    import flash.external.ExternalInterface;

    public class Console {

        private static var _id:Number = 0;

        private static function checkEnabled():Boolean {
            return ExternalInterface.available;
        }

        public static function log(msg:String):void {
            if (checkEnabled()) {
                ExternalInterface.call("console.log", "[sam " + _id + " (" + Stats.elapsedTime("ad manager") + ")]: " + msg);
            }
        }

        public static function obj(msg:*):void {
            if (checkEnabled()) {
                ExternalInterface.call("console.log", msg);
            }
        }

        public static function set sessionID(val:Number):void {
            _id = val;
        }

    }

}