package com.sovrn.ads {

    import com.sovrn.constants.Config;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.model.ApplicationVO;
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

        /*

         addelivery?
         vtid=v_333029_3071aa2ce6e843879e2ce9eaf130651f&
         zoneid=333029&
         u=DingIt&
         sovrnid=DingIt&
         loc=http://www.dingit.tv/highlight/1274169&
         od=dingit.tv&
         vidwidth=650&
         vidheight=319&
         vidautoplay=1&
         vidmimes=application/x-shockwave-flash%2Cvideo/mp4%2Cvideo/x-flv&
         vidlinearity=1&
         vidmindur=5&
         vidmaxdur=60&
         vidprotocol=1%2C2%2C4%2C5&
         vidstartdelay=0

         */

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
            var uri:String = "//";
            uri += config.server;
            uri += "/" + Config.ENDPOINT_ADS;
            uri += "?";

            uri += ObjectTools.paramString({
                zoneid: config.zoneId,
                u: config.publisherId,
                sovrnid: config.publisherId,
                loc: config.trueLoc,
                vtid: config.vtid,
                od: config.trueDomain,
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