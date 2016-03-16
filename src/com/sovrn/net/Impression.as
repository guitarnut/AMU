package com.sovrn.net {

    import com.sovrn.constants.Config;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.ApplicationVO;

    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class Impression {

        private var config:ApplicationVO;

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
        }
    }
}