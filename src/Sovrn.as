package {

    import com.sovrn.ads.AdCall;
    import com.sovrn.ads.AdController;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.model.ApplicationVO;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.StringTools;
    import com.sovrn.vpaid.VPAIDWrapper;

    import flash.display.Sprite;
    import flash.system.Security;
    import flash.utils.setTimeout;

    public class Sovrn extends Sprite {

        private var applicationConfig:ApplicationVO;
        private var vpaid:VPAIDWrapper;
        private var adController:AdController;
        private var adCall:AdCall;
        private var initCalled:Boolean;
        private var adDeliveryCalled:Boolean;

        public function Sovrn() {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");

            try {
                //loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
            } catch (e:Error) {
                //
            }

            initCalled = false;
            adDeliveryCalled = false;

            vpaid = new VPAIDWrapper();
            vpaid.addEventListener(AdManagerEvent.INIT_AD_CALLED, serveAds);

            adController = new AdController();
            vpaid.adController = adController;

            Console.log("initializing");

            config();
        }

        public function getVPAID():* {
            return vpaid;
        }

        private function config():void {
            if (this.loaderInfo.parameters) {
                var params:Object = this.loaderInfo.parameters;

                applicationConfig = new ApplicationVO();
                applicationConfig.parameters = params;
                applicationConfig.publisherId = params.u || params.sovrnid;
                applicationConfig.publisherLoc = params.loc;
                applicationConfig.vtid = params.vtid;
                applicationConfig.zoneId = params.zoneid;
                applicationConfig.server = params.ljt;
                applicationConfig.stageWidth = params.vidwidth || this.width || 0;
                applicationConfig.stageHeight = params.vidheight || this.height || 0;
                applicationConfig.trueLoc = "";
                applicationConfig.trueDomain = StringTools.domain("");

                if (validateConfig()) {
                    Console.log("config complete");
                    getAds();
                } else {
                    Console.log("invalid config");
                    vpaid.adError();
                    end();
                }
            } else {
                setTimeout(function ():void {
                    config();
                }, 200)
            }
        }

        private function validateConfig():Boolean {
            var valid:Boolean = true;

            valid = Boolean(applicationConfig.zoneId != 0) &&
                    Boolean(applicationConfig.vtid != null) &&
                    Boolean(applicationConfig.publisherId != null);

            return valid;
        }

        private function getAds():void {
            adCall = new AdCall(applicationConfig);
            adCall.addEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
        }

        private function serveAds(e:AdManagerEvent):void {
            switch (e.type) {
                case AdManagerEvent.AD_DELIVERY_COMPLETE:
                    adCall.removeEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
                    adController.ads = e.data.ads;
                    adDeliveryCalled = true;
                    Console.log("ad delivery complete");
                    break;
                case AdManagerEvent.INIT_AD_CALLED:
                    adController.initConfig = e.data;
                    initCalled = true;
                    Console.log("initAd() called");
                    break;
            }

            if (initCalled && adDeliveryCalled) {
                adController.loadAd();
            }
        }

        private function end():void {
            adController = null;
            initCalled = false;
            adDeliveryCalled = false;
        }

    }

}