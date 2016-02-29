package com.sovrn.ads {
    import com.sovrn.constants.Config;
    import com.sovrn.xml.XMLController;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class AdCall extends Sprite {

        private static const VIDEO_MIMES:Array = ['video/mp4','application/shockwave-x'];
        private static const PROTOCOLS:Array = [];
        private var config:Object;
        private var xmlController:XMLController;
        private var adsCollection:Array;

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
        }

        private function adsReady(e:Event):void {
            e.stopImmediatePropagation();
            adsCollection = xmlController.sources;

            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function buildURI():String {
            var uri:String = "";
            uri += config.server;
            uri += "/" + Config.ENDPOINT_ADS;
            uri += "?";

            return uri;
        }

        public function get sources():Array {
            return adsCollection;
        }

    }

}