package com.sovrn.ads {
    import com.sovrn.events.AdCueEvent;

    import flash.display.Sprite;

    public class AdController extends Sprite {

        private var adCue:AdCue;
        private var adInstance:*;

        public function AdController():void {

        }

        public function setAds(ads:Array):void {
            adCue = new AdCue(ads);
            adCue.addEventListener(AdCueEvent.AD_CUE_READY, adLoaded);
            adCue.addEventListener(AdCueEvent.AD_CUE_EMPTY, noAds);
            adCue.addEventListener(AdCueEvent.AD_CUE_ERROR, adError);
            adCue.addEventListener(AdCueEvent.AD_CUE_TIMEOUT, adTimeout);
            adCue.addEventListener(AdCueEvent.AD_CUE_IMPRESSION, adImpression);
        }

        public function loadAd():void {
            adCue.start();
        }

        private function adLoaded(e:AdCueEvent):void {
            adInstance = e.data.vpaid;
        }

        private function noAds(e:AdCueEvent):void {

        }

        private function adError(e:AdCueEvent):void {
            logSourceResult(e.data);
            waterfall();
        }

        private function adTimeout(e:AdCueEvent):void {
            logSourceResult(e.data);
            waterfall();
        }

        private function adImpression(e:AdCueEvent):void {
            logSourceResult(e.data);
        }

        private function waterfall():void {
            adCue.next();
        }

        private function logSourceResult(data:Object):void {

        }

        public function callAdMethod(method:String, args:Array):void {
            var args:Array = args || [];

            try {
                adInstance[method].call(adInstance, args);
            } catch (e:Error) {
                //
            }
        }

        public function get ad():* {
            return this.adInstance;
        }

    }

}