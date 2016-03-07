package {

// http://ap.rh.lijit.com/www/admanager/Sovrn.swf?zoneid=1&vtid=2&u=3
// http://ap.rh.lijit.com/addelivery?datafile=admanager

    import com.sovrn.ads.AdCall;
    import com.sovrn.ads.AdController;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.model.ApplicationVO;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.ObjectTools;
    import com.sovrn.utils.StringTools;
    import com.sovrn.video.VideoPlayer;
    import com.sovrn.view.Canvas;
    import com.sovrn.vpaid.VPAIDWrapper;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.UncaughtErrorEvent;
    import flash.system.Security;
    import flash.utils.setTimeout;

    import vpaid.VPAIDEvent;

    public class Sovrn extends Sprite {

        private var applicationConfig:ApplicationVO;
        private var vpaid:VPAIDWrapper;
        private var adController:AdController;
        private var adCall:AdCall;
        private var initCalled:Boolean;
        private var adDeliveryCalled:Boolean;
        private var sessionStarted:Boolean = false;
        private var session:int;
        private var view:Canvas;

        public function Sovrn() {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");

            try {
                loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
            } catch (e:Error) {
                // no loader info object available?
            }

            vpaid = new VPAIDWrapper();
            com.sovrn.vpaid.VPAIDWrapper(vpaid).addEventListener(AdManagerEvent.INIT_AD_CALLED, serveAds);
            com.sovrn.vpaid.VPAIDWrapper(vpaid).addEventListener(VPAIDEvent.AdError, end);
            com.sovrn.vpaid.VPAIDWrapper(vpaid).addEventListener(VPAIDEvent.AdStopped, end);

            adController = new AdController();
            com.sovrn.vpaid.VPAIDWrapper(vpaid).controller = adController;

            view = new Canvas();
            view.x = 0;
            view.y = 0;
            view.show();
            addChild(view);

            addEventListener(Event.ADDED_TO_STAGE, setupView);

            initCalled = false;
            adDeliveryCalled = false;
            session = 1;

            Console.log("initializing");

            config();
        }

        private function uncaughtErrorHandler(e:UncaughtErrorEvent):void {
            Console.log('UncaughtError:');

            var message:String;

            if (e.error is Error) {
                message = Error(e.error).message;
            }
            else if (e.error is ErrorEvent) {
                message = ErrorEvent(e.error).text;
            }
            else {
                message = e.error.toString();
            }

            Console.log(message);
        }

        public function getVPAID():* {
            Console.log('getVPAID() called');
            return vpaid;
        }

        private function setupView(e:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, setupView);

            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;

            if (applicationConfig) view.resize(applicationConfig.stageWidth, applicationConfig.stageHeight);
        }

        private function config():void {
            if (this.loaderInfo.parameters) {
                var params:Object = this.loaderInfo.parameters;

                applicationConfig = new ApplicationVO();
                applicationConfig.parameters = params || {};
                applicationConfig.publisherId = params.u || params.sovrnid || "";
                applicationConfig.publisherLoc = params.loc || "";
                applicationConfig.vtid = params.vtid || "";
                applicationConfig.zoneId = params.zoneid || 0;
                applicationConfig.server = params.ljt || "";
                applicationConfig.stageWidth = params.vidwidth || this.width || 0;
                applicationConfig.stageHeight = params.vidheight || this.height || 0;
                applicationConfig.trueLoc = "";
                applicationConfig.trueDomain = StringTools.domain("");
                applicationConfig.view = view;

                if (validateConfig()) {
                    Console.log("config complete");
                    getAds();
                } else {
                    Console.log("invalid config");
                    com.sovrn.vpaid.VPAIDWrapper(vpaid).fireAdError();
                }
            } else {
                setTimeout(function ():void {
                    config();
                }, 200)
            }
        }

        private function validateConfig():Boolean {
            return Boolean(applicationConfig.zoneId != 0) &&
                    Boolean(applicationConfig.vtid != null) &&
                    Boolean(applicationConfig.publisherId != null);
        }

        private function getAds():void {
            adCall = new AdCall(applicationConfig);
            adCall.addEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
            adCall.sendRequest();
        }

        private function serveAds(e:*):void {
            switch (e.type) {
                case AdManagerEvent.AD_DELIVERY_COMPLETE:
                    adCall.removeEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
                    adCall = null;
                    adController.ads = e.data.ads;
                    adDeliveryCalled = true;
                    break;
                case AdManagerEvent.INIT_AD_CALLED:
                    sessionStarted = true;
                    adController.initConfig = e.data;
                    initCalled = true;
                    Console.log("initAd() called -\n" + ObjectTools.values(e.data));
                    if (session > 1 && !adDeliveryCalled) getAds();
                    break;
            }

            if (initCalled && adDeliveryCalled) {
                Console.log('sources loaded and initAd() called, starting VPAID');
                adController.view = applicationConfig.view;
                adController.loadAd();
            }
        }

        private function end(e:Event = null):void {
            Console.log('end() called');

            if (sessionStarted) {
                sessionStarted = false;
                adController.reset();
                initCalled = false;
                adDeliveryCalled = false;
                view.hide();
                session++;
            }
        }

    }

}