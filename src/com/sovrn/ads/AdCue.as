package com.sovrn.ads {
    import com.sovrn.events.AdCueEvent;
    import com.sovrn.model.InitConfigVO;

    import flash.display.Sprite;

    public class AdCue extends Sprite {

        private var ads:Array;
        private var currentAd:IAdInstance;
        private var initConfig:InitConfigVO;

        public function AdCue(ads:Array) {
            this.ads = ads;
        }

        public function start(obj:InitConfigVO):void {
            initConfig = obj;
            loadAd();
        }

        private function loadAd():void {
            if(ads.length > 0) {
                currentAd = IAdInstance(ads[0]);
            } else {
                dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_EMPTY));
            }
        }

        private function adReady():void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_READY));
        }

        public function next():void {
            ads.splice(0,1);
            loadAd();
        }

        private function destroyAd():void {

        }

        public function stop():void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_COMPLETE));
        }

    }

}