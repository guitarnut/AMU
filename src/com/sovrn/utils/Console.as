package com.sovrn.utils {

    import flash.external.ExternalInterface;

    public class Console {

        private static function checkEnabled():Boolean {
            return ExternalInterface.available;
        }

        public static function log(msg:String):void {
            if(checkEnabled()) {
                ExternalInterface.call("console.log", msg);
            }
        }

        public static function obj(msg:*):void {
            if(checkEnabled()) {
                ExternalInterface.call("console.log", msg);
            }
        }

    }

}