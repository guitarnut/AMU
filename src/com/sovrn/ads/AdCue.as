package com.sovrn.ads {
    import com.sovrn.events.AdCueEvent;

    import flash.display.Sprite;

    public class AdCue extends Sprite {

        private var ads:Array;
        private var currentAd:IAdInstance;

        public function AdCue(ads:Array) {
            this.ads = ads;
        }

        public function start():void {
            loadAd();
        }

        private function loadAd():void {
            if(ads.length > 0) {
                currentAd = IAdInstance(ads[0]);
            } else {
                dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_EMPTY));
            }
        }

        public function next():void {
            ads.splice(0,1);
            loadAd();
        }

    }

}