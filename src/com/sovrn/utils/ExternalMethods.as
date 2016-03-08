package com.sovrn.utils {

    import flash.external.ExternalInterface;

    public class ExternalMethods {
        public static var avail:Boolean = false;
        public static var debug:Boolean;
        private static var _cookie:String = "LJT_DEBUG=true";

        public function ExternalMethods() {

        }

        public static function available():Boolean {
            try {
                if (ExternalInterface.available) {
                    Console.log("ExternalInterface available");
                    avail = true;
                }
            } catch (e:Error) {
                //
            }

            return avail;
        }

        public static function checkDebug():Boolean {
            if (debug) return debug;

            if (avail) {
                debug = (ExternalInterface.call('document.cookie.indexOf("' + _cookie + '").toString') != "-1");
            }

            return debug;
        }

        public static function inject(script:String):void {
            if (avail) ExternalInterface.call("eval", script);
        }

        public static function userLoc():String {
            var loc:String = (avail) ? ExternalInterface.call("sovrn.utils.loc") : "undefined";
            return loc;
        }

        public static function referrer():String {
            var ref:String = (avail) ? ExternalInterface.call("sovrn.utils.referrer") : "undefined";
            return ref;
        }

        public static function beacon(uri:String = ""):void {
            if (avail) ExternalInterface.call("sovrn.utils.beacon", uri);
        }

    }
}