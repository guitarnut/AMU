package com.sovrn.events {
    import flash.events.Event;

    public class AdCueEvent extends Event {

        public static const AD_CUE_READY:String = "AD_CUE_READY";
        public static const AD_CUE_IMPRESSION:String = "AD_CUE_IMPRESSION";
        public static const AD_CUE_COMPLETE:String = "AD_CUE_COMPLETE";
        public static const AD_CUE_TIMEOUT:String = "AD_CUE_TIMEOUT";
        public static const AD_CUE_ERROR:String = "AD_CUE_ERROR";
        public static const AD_CUE_EMPTY:String = "AD_CUE_EMPTY";

        private var _data:Object;

        public function AdCueEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = true):void {
            super(type, bubbles, cancelable);

            this._data = data;
        }

        public function get data():Object {
            return this._data;
        }

    }

}