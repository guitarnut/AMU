package {

// http://ap.rh.lijit.com/www/admanager/Sovrn.swf?zoneid=1&vtid=2&u=3&datafile=wf2&ljt=ap.rh.lijit.com
// http://ap.rh.lijit.com/addelivery?datafile=admanager

    import com.sovrn.ads.AdCall;
    import com.sovrn.ads.AdController;
    import com.sovrn.constants.Config;
    import com.sovrn.constants.Errors;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.model.ApplicationVO;
    import com.sovrn.net.Beacon;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.ExternalMethods;
    import com.sovrn.utils.ObjectTools;
    import com.sovrn.utils.Stats;
    import com.sovrn.utils.StringTools;
    import com.sovrn.utils.Timeouts;
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

        [Embed(source="../js/sovrn.js", mimeType="application/octet-stream")]
        private var js:Class;

        private var applicationConfig:ApplicationVO;
        private var vpaid:VPAIDWrapper;
        private var adController:AdController;
        private var adCall:AdCall;
        private var initCalled:Boolean;
        private var adDeliveryCalled:Boolean;
        private var sessionStarted:Boolean = false;
        private var adLoaded:Boolean = false;
        private var session:int;
        private var view:Canvas;
        private var beacon:Beacon;

        public function Sovrn() {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");

            Stats.timeThis("ad manager");

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

            setupStage();

            addEventListener(Event.ADDED_TO_STAGE, addedToStage);

            initCalled = false;
            adDeliveryCalled = false;
            session = 1;

            Console.log("---------------------------------");
            Console.log("Sovrn Ad Manager");
            Console.log("---------------------------------");

            if (ExternalMethods.available()) ExternalMethods.inject(new js().toString());

            config();
        }

        private function uncaughtErrorHandler(e:UncaughtErrorEvent):void {
            var message:String = "";

            if (e.error is Error) {
                message = Error(e.error).message;
            }
            else if (e.error is ErrorEvent) {
                message = ErrorEvent(e.error).text;
            }
            else {
                message = e.error.toString();
            }

            Console.log('UncaughtError: ' + message);
        }

        public function getVPAID():* {
            Console.log('getVPAID() called');
            return vpaid;
        }

        private function fireAdError(error:Number = 0):void {
            com.sovrn.vpaid.VPAIDWrapper(vpaid).fireAdError(error);
        }

        private function setupStage():void {
            if (view) {
                view.cleanup();
                removeChild(view);
                view = new Canvas();
                view.hide();
                addChild(view);
                applicationConfig.view = view;
            } else {
                view = new Canvas();
                view.x = 0;
                view.y = 0;
                view.show();
                addChild(view);
            }
        }

        private function addedToStage(e:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;

            if (applicationConfig) view.resize(applicationConfig.stageWidth, applicationConfig.stageHeight);
        }

        private function config():void {
            if (this.loaderInfo.parameters) {
                var params:Object = this.loaderInfo.parameters;

                Timeouts.setValues(params);

                applicationConfig = new ApplicationVO();
                applicationConfig.parameters = params || {};
                applicationConfig.publisherId = params.u || params.sovrnid || "";
                applicationConfig.publisherLoc = params.loc || "";
                applicationConfig.vtid = params.vtid || "";
                applicationConfig.zoneId = params.zoneid || 0;
                applicationConfig.server = params.ljt || Config.SERVER;
                applicationConfig.stageWidth = params.vidwidth || this.width || 0;
                applicationConfig.stageHeight = params.vidheight || this.height || 0;
                applicationConfig.trueLoc = ExternalMethods.userLoc() || "";
                applicationConfig.trueDomain = StringTools.domain(applicationConfig.trueLoc);
                applicationConfig.view = view;

                Log.init(applicationConfig);

                if (validateConfig()) {
                    Log.msg(Log.AD_MANAGER_INITIALIZED, "session_" + session);

                    Log.custom({
                        orig_loc: applicationConfig.publisherLoc,
                        loc: applicationConfig.trueLoc,
                        domain: applicationConfig.trueDomain,
                        width: params.width || "undefined",
                        height: params.height || "undefined"
                    });

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
            Timeouts.start(Timeouts.AD_DELIVERY_CALL, fireAdError, vpaid, [Errors.ADDELIVERY_TIMEOUT]);
            adCall = new AdCall(applicationConfig);
            adCall.addEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
            adCall.sendRequest();
        }

        private function serveAds(e:*):void {
            switch (e.type) {
                case AdManagerEvent.AD_DELIVERY_COMPLETE:
                    Timeouts.stop(Timeouts.AD_DELIVERY_CALL);
                    Log.msg(Log.AD_DELIVERY_COMPLETE);

                    adCall.removeEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
                    adCall = null;
                    adController.ads = e.data.ads;
                    adDeliveryCalled = true;
                    applicationConfig.tid = e.data.ads[0].tid || "";
                    break;
                case AdManagerEvent.INIT_AD_CALLED:
                    if (!sessionStarted) {
                        sessionStarted = true;
                        adController.initConfig = e.data;
                        initCalled = true;
                        view.resize(e.data.width, e.data.height);

                        Console.log(ObjectTools.values(e.data));

                        if (session > 1 && !adDeliveryCalled) getAds();
                    }
                    break;
            }

            if (initCalled && adDeliveryCalled) {
                if (!adLoaded) {

                    if (!beacon) {
                        beacon = new Beacon(applicationConfig);
                        beacon.fire();
                    }

                    adLoaded = true;

                    Console.log('starting VPAID');

                    view.show();
                    adController.view = applicationConfig.view;
                    adController.loadAd();
                }
            }
        }

        private function end(e:Event = null):void {
            if (e.type == VPAIDEvent.AdError) Log.msg(Log.END_SESSION);
            if (e.type == VPAIDEvent.AdStopped && !adController.impression) Log.msg(Log.END_SESSION);

            if (sessionStarted) {
                sessionStarted = false;
                initCalled = false;
                adDeliveryCalled = false;
                adLoaded = false;
                adController.reset();
                session++;

                setupStage();
            }
        }

    }

}