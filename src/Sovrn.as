package {

// http://ap.rh.lijit.com/www/admanager/Sovrn.swf?zoneid=1&vtid=2&u=3&datafile=wf2&ljt=ap.rh.lijit.com
// http://ap.rh.lijit.com/addelivery?datafile=admanager

    import com.sovrn.ads.AdCall;
    import com.sovrn.ads.AdController;
    import com.sovrn.constants.Config;
    import com.sovrn.constants.Errors;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.model.ApplicationVO;
    import com.sovrn.net.Impression;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.ExternalMethods;
    import com.sovrn.utils.ObjectTools;
    import com.sovrn.utils.Stats;
    import com.sovrn.utils.StringTools;
    import com.sovrn.utils.Timeouts;
    import com.sovrn.view.Canvas;
    import com.sovrn.vpaid.VPAIDState;
    import com.sovrn.vpaid.VPAIDWrapper;

    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.UncaughtErrorEvent;
    import flash.system.Security;
    import flash.utils.setTimeout;

    import org.openvv.OVVAsset;

    import vpaid.VPAIDEvent;

    public class Sovrn extends VPAIDWrapper {

        [Embed(source="./js/sovrn.js", mimeType="application/octet-stream")]
        private var js:Class;

        private var beacon:OVVAsset;
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

        public function Sovrn() {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");

            Stats.timeThis("ad manager");

            try {
                loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
            } catch (e:Error) {
                // no loader info object available?
            }

            addEventListener(AdManagerEvent.INIT_AD_CALLED, serveAds);
            addEventListener(VPAIDEvent.AdError, end);
            addEventListener(VPAIDEvent.AdStopped, end);

            adController = new AdController();
            controller = adController;

            setupStage();

            addEventListener(Event.ADDED_TO_STAGE, addedToStage);

            initCalled = false;
            adDeliveryCalled = false;
            session = 1;

            beacon = new OVVAsset('OVVBeacon.swf');

            VPAIDState.reset();

            if (ExternalMethods.available()) ExternalMethods.inject(new js().toString());

            Console.sessionID = Math.round(Math.random() * 1E5);

            Console.log("---------------------------------");
            Console.log("Sovrn Ad Manager");
            Console.log("---------------------------------");

            config();
        }

        private function uncaughtErrorHandler(e:UncaughtErrorEvent):void {
            e.stopImmediatePropagation();

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

        private function config():void {
            if (this.loaderInfo.parameters) {
                var params:Object = this.loaderInfo.parameters;
                Console.obj(params);
                Timeouts.setValues(params);

                var viewability:Object = beacon.checkViewability();
                var videoWidth:Number = viewability.objRight - viewability.objLeft;
                var videoHeight:Number = viewability.objBottom - viewability.objTop;

                applicationConfig = new ApplicationVO();
                applicationConfig.parameters = params || {};
                applicationConfig.publisherId = params.u || params.sovrnid || "";
                applicationConfig.publisherLoc = params.loc || "";
                applicationConfig.vtid = params.vtid || "";
                applicationConfig.zoneId = params.zoneid || 0;
                applicationConfig.server = params.ljt || Config.SERVER;
                applicationConfig.stageWidth = videoWidth || params.vidwidth || this.width || 0;
                applicationConfig.stageHeight = videoHeight || params.vidheight || this.height || 0;
                applicationConfig.trueLoc = ExternalMethods.userLoc() || "";
                applicationConfig.trueDomain = StringTools.domain(applicationConfig.trueLoc);
                applicationConfig.view = view;
                applicationConfig.datafile = params.datafile || null;
                applicationConfig.viewability = beacon;

                Console.log(applicationConfig.server);

                Log.init(applicationConfig);
                Log.msg(Log.VIEWABILITY, ObjectTools.paramString({
                    width: applicationConfig.stageWidth,
                    height: applicationConfig.stageHeight,
                    percentViewable: viewability.percentViewable,
                    clientWidth: viewability.clientWidth,
                    clientHeight: viewability.clientHeight,
                    iframe: viewability.inIframe,
                    state: viewability.viewabilityState,
                    focus: viewability.focus
                }));

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
                    fireAdError();
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

            Console.log('added to display area');

            this.stage.align = StageAlign.TOP_LEFT;
            this.stage.scaleMode = StageScaleMode.NO_SCALE;

            if (applicationConfig) view.resize(applicationConfig.stageWidth, applicationConfig.stageHeight);
        }

        private function getAds():void {
            Timeouts.start(Timeouts.AD_DELIVERY_CALL, fireAdError, vpaid, [Errors.ADDELIVERY_TIMEOUT]);
            adCall = new AdCall(applicationConfig);
            adCall.addEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
            adCall.addEventListener(AdManagerEvent.AD_DELIVERY_FAILED, adCallFailed);
            adCall.sendRequest();
        }

        private function adCallFailed(e:Event):void {
            Timeouts.stop(Timeouts.AD_DELIVERY_CALL);
            fireAdError();
        }

        private function serveAds(e:*):void {
            switch (e.type) {
                case AdManagerEvent.AD_DELIVERY_COMPLETE:
                    Timeouts.stop(Timeouts.AD_DELIVERY_CALL);
                    Log.msg(Log.AD_DELIVERY_COMPLETE);

                    applicationConfig.tid = e.data.ads[0].tid || "";

                    adCall.removeEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
                    adCall = null;

                    adController.config = applicationConfig;
                    adController.ads = e.data.ads;

                    adDeliveryCalled = true;

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
                    adLoaded = true;

                    Console.log('starting VPAID');

                    view.show();
                    adController.view = applicationConfig.view;
                    adController.impression = new Impression(applicationConfig);
                    adController.loadAd();
                }
            }
        }

        private function end(e:Event = null):void {
            Timeouts.stop(Timeouts.AD_MANAGER_SESSION);

            if (e) {
                if (e.type == VPAIDEvent.AdError) Log.msg(Log.END_SESSION);
                if (e.type == VPAIDEvent.AdStopped && !adController.impressionFired) Log.msg(Log.END_SESSION);
            }

            sessionStarted = false;
            initCalled = false;
            adDeliveryCalled = false;
            adLoaded = false;

            adController.reset();
            session++;

            VPAIDState.reset();
            setupStage();
        }

    }

}