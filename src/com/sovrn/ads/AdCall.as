package com.sovrn.ads {

    import com.sovrn.constants.Config;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.model.ApplicationVO;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.ObjectTools;
    import com.sovrn.xml.XMLController;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class AdCall extends Sprite {

        private var config:ApplicationVO;
        private var xmlController:XMLController;
        private var vidmimes:Array = ["application/x-shockwave-flash", "video/mp4", "video/x-flv"];
        private var vidlinearity:Number = 1;
        private var vidmindur:Number = 5;
        private var vidmaxdur:Number = 60;
        private var vidprotocol:Array = [1, 2, 4, 5];
        private var vidstartdelay:Number = 0;

        public function AdCall(data:ApplicationVO) {
            this.config = data;
        }

        public function sendRequest():void {
            var load:URLLoader = new URLLoader();
            load.addEventListener(Event.COMPLETE, getSources);
            load.addEventListener(Event.COMPLETE, eventRequestCompleted);
            load.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEvents);
            load.addEventListener(IOErrorEvent.IO_ERROR, loaderEvents);

            load.load(new URLRequest(buildURI()));
        }

        private function eventRequestCompleted(e:Event):void {
            //
        }

        private function loaderEvents(e:Event):void {
            Console.log("request failed: " + e.type);
            dispatchEvent(new AdManagerEvent(AdManagerEvent.AD_DELIVERY_FAILED));
        }

        private function getSources(e:Event):void {
            xmlController = new XMLController();
            xmlController.addEventListener(Event.COMPLETE, adsReady);
            xmlController.parse(e.target.data);
        }

        private function adsReady(e:Event):void {
            e.stopImmediatePropagation();
            xmlController.removeEventListener(Event.COMPLETE, adsReady);

            if(xmlController.sources.length > 0) {
                Console.obj(xmlController.sources);
                dispatchEvent(new AdManagerEvent(AdManagerEvent.AD_DELIVERY_COMPLETE, {ads: xmlController.sources}));
            } else {
                Log.msg(Log.VAST_PARSE_ERROR, "no ad sources found");
                dispatchEvent(new AdManagerEvent(AdManagerEvent.AD_DELIVERY_FAILED));
            }

            xmlController = null;
        }

        private function buildURI():String {
            var uri:String = "//";
            uri += config.server;
            uri += "/" + Config.ENDPOINT_ADS;
            uri += "?";

            if (config.datafile) {
                Console.log('loading custom VAST');

                uri += ObjectTools.paramString({
                    datafile: config.datafile
                });

                return uri;
            }

            uri += ObjectTools.paramString({
                zoneid: config.zoneId,
                u: config.publisherId,
                sovrnid: config.publisherId,
                loc: config.trueLoc,
                vtid: config.vtid,
                od: config.trueDomain,
                vidwidth: config.stageWidth,
                vidheight: config.stageHeight,
                vidmimes: encodeURI(vidmimes.join(",")),
                vidlinearity: vidlinearity,
                vidmindur: vidmindur,
                vidmaxdur: vidmaxdur,
                vidprotocol: encodeURI(vidprotocol.join(",")),
                vidstartdelay: vidstartdelay
            });

            return uri;
        }

    }

}