package com.sovrn.net {

    import com.sovrn.constants.Config;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.ApplicationVO;

    import flash.events.TimerEvent;

    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.Timer;

    import vpaid.VPAIDEvent;

    public class Impression {

        private const VIEWABLE_IMP_POLL:Number = 200;
        private const VIEWABLE_IMP_POLL_COUNT:Number = 5;
        private const VIEWABLE:String = 'viewable';
        private var config:ApplicationVO;
        private var viewCheck:Timer;
        private var pollCount:Number = 0;
        private var viewableImpressionFired:Boolean = false;

        public function Impression(app:ApplicationVO) {
            config = app;
        }

        public function fire(ad:AdVO):void {
            var uri:String = "//" + config.server;
            uri += "/" + Config.ENDPOINT_IMPRESSIONS;
            uri += "?";
            uri += ["zoneid=" + config.zoneId, "bannerid=" + ad.bannerId, "tid=" + ad.tid, "cb=" + ad.cb, "campaignid=" + ad.campaignId].join("&");

            var imp:URLLoader = new URLLoader();
            imp.load(new URLRequest(uri));

            checkViewableImpression();
        }

        private function checkViewableImpression():void {
            viewCheck = new Timer(VIEWABLE_IMP_POLL, 0);
            viewCheck.addEventListener(TimerEvent.TIMER, checkViewability);
            viewCheck.start();
        }

        private function checkViewability(e:TimerEvent):void {
            if (config.viewability.checkViewability().viewabilityState == VIEWABLE) {
                pollCount++;
                if (pollCount == VIEWABLE_IMP_POLL_COUNT) fireViewableImpression();
            }
        }

        public function fireViewableImpression(clicked:Boolean = false):void {
            if (viewableImpressionFired) return;

            viewableImpressionFired = true;

            if (viewCheck) {
                viewCheck.stop();
                viewCheck.removeEventListener(TimerEvent.TIMER, checkViewability);
            }

            Log.custom({
                vpaidEvent: VPAIDEvent.ImpressionViewable,
                vpaidEventData: (clicked) ? "clicked" : ""
            })
        }
    }
}