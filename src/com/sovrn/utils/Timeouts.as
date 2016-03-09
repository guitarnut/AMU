package com.sovrn.utils {

    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;

    public class Timeouts {

        public static var AD_DELIVERY_CALL:String = "AD_DELIVERY_CALL";
        public static var AD_MANAGER_SESSION:String = "AD_MANAGER_SESSION";
        public static var LOAD_AD:String = "LOAD_AD";
        public static var AD_SESSION:String = "AD_SESSION";
        public static var DESTROY:String = "DESTROY";
        public static var LOAD_WRAPPER:String = "LOAD_WRAPPER";
        public static var LOAD_VIDEO:String = "LOAD_VIDEO";

        private static var timeouts:Object = {
            AD_DELIVERY_CALL: {
                param: 'ft1',
                value: 5
            },
            AD_MANAGER_SESSION: {
                param: 'ft2',
                value: 40
            },
            LOAD_AD: {
                param: 'ft3',
                value: 5
            },
            AD_SESSION: {
                param: 'ft4',
                value: 12
            },
            DESTROY: {
                param: 'ft5',
                value: 0.5
            },
            LOAD_WRAPPER: {
                param: 'ft6',
                value: 3
            },
            LOAD_VIDEO: {
                param: 'ft7',
                value: 5
            }
        };

        private static var timeoutCue:Object = {};

        public static function setValues(params:Object):void {
            for (var key:String in timeouts) {
                if (params.hasOwnProperty(timeouts[key].param)) {
                    timeouts[key].value = Number(params[timeouts[key].param]);
                }
            }

            Console.obj(timeouts);
        }

        private static function getValue(val:String):Number {
            if (timeouts.hasOwnProperty(val)) {
                return timeouts[val].value * 1000;
            }

            return 0;
        }

        public static function start(name:String, callback:Function, context:*, args:Array):void {
            if (!timeoutCue.hasOwnProperty(name)) {
                var t:Timer = new Timer(getValue(name));

                t.addEventListener(TimerEvent.TIMER_COMPLETE, function (e:TimerEvent):void {
                    Console.log('timeout ' + name + ' fired');
                    callback.apply(context, args);
                });

                timeoutCue[name] = t;
                t.start();

                Console.log("set " + name + " timeout");
            }
        }

        public static function stop(name:String):void {
            if (timeoutCue.hasOwnProperty(name)) {
                timeoutCue[name].stop();
                Console.log("cleared " + name + " timeout");
            }
        }

    }

}