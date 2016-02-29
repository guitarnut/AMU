package com.sovrn.ads {
    import com.sovrn.constants.Config;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.xml.XMLController;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class AdCall extends Sprite {

        private var config:Object;
        private var xmlController:XMLController;

        public function AdCall(config:Object) {
            this.config = config;
        }

        public function sendRequest():void {
            var load:URLLoader = new URLLoader();
            load.addEventListener(Event.COMPLETE, getSources);
            load.load(new URLRequest('//ap.rh.lijit.com/addelivery?datafile=waterfall'));
        }

        private function getSources(e:Event):void {
            xmlController = new XMLController();
            xmlController.addEventListener(Event.COMPLETE, adsReady);
            xmlController.parse(e.target.data);
        }

        private function adsReady(e:Event):void {
            e.stopImmediatePropagation();
            xmlController.removeEventListener(Event.COMPLETE, adsReady);

            dispatchEvent(new AdManagerEvent(AdManagerEvent.AD_DELIVERY_COMPLETE, {ads: xmlController.sources}));

            xmlController = null;
        }

        private function buildURI():String {
            var uri:String = "";
            uri += config.server;
            uri += "/" + Config.ENDPOINT_ADS;
            uri += "?";

            return uri;
        }

    }

}