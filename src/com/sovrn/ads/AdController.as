package com.sovrn.ads {

    import com.sovrn.events.AdCueEvent;
    import com.sovrn.model.InitConfigVO;

    import flash.display.Sprite;
    import flash.events.EventDispatcher;

    import vpaid.VPAIDEvent;

    public class AdController extends Sprite {

        private var adCue:AdCue;
        private var _initConfig:InitConfigVO;
        private var adInstance:*;
        private var allowedVPAIDEvents:Array;
        private var dispatcher:EventDispatcher;

        public function AdController():void {
            dispatcher = new EventDispatcher();

            allowedVPAIDEvents = [
                // VPAIDEvent.AdLoaded,
                VPAIDEvent.AdStarted,
                VPAIDEvent.AdStopped,
                // VPAIDEvent.AdSkipped,
                VPAIDEvent.AdLinearChange,
                VPAIDEvent.AdExpandedChange,
                VPAIDEvent.AdRemainingTimeChange,
                VPAIDEvent.AdVolumeChange,
                // VPAIDEvent.AdImpression,
                VPAIDEvent.AdVideoStart,
                VPAIDEvent.AdVideoFirstQuartile,
                VPAIDEvent.AdVideoMidpoint,
                VPAIDEvent.AdVideoThirdQuartile,
                VPAIDEvent.AdVideoComplete,
                VPAIDEvent.AdClickThru,
                // VPAIDEvent.AdUserAcceptInvitation,
                VPAIDEvent.AdUserMinimize,
                VPAIDEvent.AdUserClose,
                VPAIDEvent.AdPaused,
                VPAIDEvent.AdPlaying,
                VPAIDEvent.AdLog,
                // VPAIDEvent.AdError,
                VPAIDEvent.AdSizeChange,
                VPAIDEvent.AdSkippableStateChange,
                VPAIDEvent.AdDurationChange,
                VPAIDEvent.AdInteraction
            ]
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
            allowedVPAIDEvents.map(function(val, index, array) {
                adInstance.addEventListener(val, dispatchAdEvent);
            });
        }

        private function dispatchAdEvent(e:VPAIDEvent):void {
            dispatcher.dispatchEvent(new VPAIDEvent(e.type));
        }

        public function loadAd():void {
            adCue.start(_initConfig);
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
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped));
        }

        private function waterfall():void {
            adCue.next();
        }

        private function logSourceResult(data:Object):void {
        }

        public function callAdMethod(method:String, arguments:Array):void {
            var args:Array = arguments || [];

            if (adInstance) {
                try {
                    adInstance[method].call(adInstance, args);
                } catch (e:Error) {
                    //
                }
            }
        }

    }

}