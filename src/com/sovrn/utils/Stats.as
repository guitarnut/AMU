package com.sovrn.utils {

    import flash.utils.getTimer;

    public class Stats {
        private static var times:Object = {};

        public static function runtime():Number {
            return getTimer() / 1000;
        }

        public static function timeThis(name:String):void {
            if(!times.hasOwnProperty(name)) {
                times[name] = {"startTime": runtime()};
            }
        }

        public static function elapsedTime(name:String):Number {
            if(times.hasOwnProperty(name)) {
                var t:String = Number(runtime() - times[name].startTime).toFixed(3);
                return Number(t);
            }
            return 0;
        }
    }
}