package com.sovrn.ads {

    import com.sovrn.constants.AdVPAIDEvents;
    import com.sovrn.events.AdCueEvent;
    import com.sovrn.model.InitConfigVO;
    import com.sovrn.utils.Console;

    import flash.display.Sprite;
    import flash.events.EventDispatcher;

    import vpaid.VPAIDEvent;

    public class AdController extends Sprite {

        private var adCue:AdCue;
        private var _initConfig:InitConfigVO;
        private var adInstance:*;
        private var dispatcher:EventDispatcher;

        public function AdController():void {
            dispatcher = new EventDispatcher();
        }

        public function set ads(ads:Array):void {
            adInstance = null;

            adCue = new AdCue(ads);
            adCue.addEventListener(AdCueEvent.AD_CUE_READY, adLoaded);
            adCue.addEventListener(AdCueEvent.AD_CUE_EMPTY, noAds);
            adCue.addEventListener(AdCueEvent.AD_CUE_ERROR, sourceFailed);
            adCue.addEventListener(AdCueEvent.AD_CUE_TIMEOUT, sourceFailed);
            adCue.addEventListener(AdCueEvent.AD_CUE_IMPRESSION, adImpression);
            adCue.addEventListener(AdCueEvent.AD_CUE_COMPLETE, adStopped);
        }

        public function set initConfig(obj:Object):void {
            _initConfig = new InitConfigVO();
            _initConfig.width = obj.width;
            _initConfig.height = obj.height;
            _initConfig.viewMode = obj.viewMode;
            _initConfig.desiredBitrate = obj.desiredBitrate;
            _initConfig.creativeData = obj.creativeData;
            _initConfig.environmentVars = obj.environmentVars;
        }

        public function get adEventDispatcher():EventDispatcher {
            return dispatcher;
        }

        // these are the vpaid events we will allow to bubble up
        private function addAdEvents():void {
            AdVPAIDEvents.ALLOWED_EVENTS.map(function (val:String, index:Number, array:Array):void {
                adInstance.addEventListener(val, dispatchAdEvent);
            });
        }

        private function removeAdEvents():void {
            if (adInstance) {
                AdVPAIDEvents.ALLOWED_EVENTS.map(function (val:String, index:Number, array:Array):void {
                    adInstance.removeEventListener(val, dispatchAdEvent);
                });
            }
        }

        private function dispatchAdEvent(e:VPAIDEvent):void {
            dispatcher.dispatchEvent(new VPAIDEvent(e.type));
        }

        public function loadAd():void {
            adCue.start(_initConfig);
        }

        public function callAdMethod(method:String, arguments:Array = null, defaultValue:* = null, property:String = ""):* {
            arguments = arguments || [];
            defaultValue = defaultValue || null;

            if (adInstance) {
                try {
                    switch (property) {
                        case 'get':
                            Console.log('get');
                            return adInstance[method];
                            break;
                        case 'set':
                            Console.log('set');
                            adInstance[method] = arguments[0];
                            break;
                        default:
                            Console.log('default');
                            adInstance[method].apply(adInstance, arguments);
                            break;
                    }
                } catch (e:Error) {
                    Console.log('error: ' + e.toString());
                    if (defaultValue) return defaultValue;
                }
            } else {
                Console.log('no ad, returning default: ' + defaultValue);
                if (defaultValue) return defaultValue;
            }
        }

        public function stop():void {
            removeAdEvents();
        }

        private function adLoaded(e:AdCueEvent):void {
            adInstance = e.data.vpaid;
            addAdEvents();
        }

        private function noAds(e:AdCueEvent):void {
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError));
        }

        private function sourceFailed(e:AdCueEvent):void {
            logSourceResult(e.data);
            waterfall();
        }

        private function adImpression(e:AdCueEvent):void {
            logSourceResult(e.data);
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression));
        }

        private function adStopped(e:AdCueEvent):void {
            stop();
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped));
        }

        private function waterfall():void {
            adCue.next();
        }

        private function logSourceResult(data:Object):void {
        }

    }

}