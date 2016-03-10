package com.sovrn.events {

    import com.sovrn.utils.Console;

    import flash.events.Event;

    public class AdInstanceEvent extends Event {

        public static const AdError:String = "AdError";
        public static const AdLoaded:String = "AdLoaded";
        public static const AdTimeout:String = "AdTimeout";
        public static const AdImpression:String = "AdImpression";
        public static const AdStopped:String = "AdStopped";
        public static const AdPaused:String = "AdPaused";

        private var _data:Object;

        public function AdInstanceEvent(eventType:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = true):void {
            super(eventType, bubbles, cancelable);

            Console.log('AdInstanceEvent: ' + eventType);

            this._data = data;
        }

        public function get data():Object {
            return this._data;
        }

    }

}