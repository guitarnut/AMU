package com.sovrn.ads {
    import com.sovrn.events.AdCueEvent;
    import com.sovrn.model.InitConfigVO;

    import flash.display.DisplayObjectContainer;

    import flash.display.DisplayObjectContainer;

    import flash.display.Sprite;

    public class AdCue extends Sprite {

        private var ads:Array;
        private var currentAd:IAdInstance;
        private var initConfig:InitConfigVO;
        private var _view:DisplayObjectContainer;

        public function AdCue(ads:Array) {
            this.ads = ads;
        }

        public function start(obj:InitConfigVO, view:DisplayObjectContainer):void {
            initConfig = obj;
            _view = view;

            loadAd();
        }

        private function loadAd():void {
            if(ads.length > 0) {
                currentAd = IAdInstance(ads[0]);
                currentAd.config = initConfig;

                _view.width = 700;
                _view.height = 450;

                currentAd.view = _view;

                currentAd.load();
            } else {
                dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_EMPTY));
            }
        }

        private function adReady():void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_READY));
        }

        public function next():void {
            currentAd.destroy();
            ads.splice(0,1);
            loadAd();
        }

        public function stop():void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_COMPLETE));
        }

    }

}