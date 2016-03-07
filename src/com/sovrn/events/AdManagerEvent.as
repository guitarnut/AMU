package com.sovrn.events {

    import com.sovrn.utils.Console;

    import flash.events.Event;

    public class AdManagerEvent extends Event {

        public static const INIT_AD_CALLED:String = "INIT_AD_CALLED";
        public static const AD_DELIVERY_COMPLETE:String = "AD_DELIVERY_COMPLETE";

        private var _data:Object;

        public function AdManagerEvent(eventType:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = true):void {
            super(eventType, bubbles, cancelable);

            Console.log('AdManagerEvent: ' + eventType);

            this._data = data;
        }

        public function get data():Object {
            return this._data;
        }

    }

}