package com.sovrn.ads {

    import com.sovrn.events.AdCueEvent;
    import com.sovrn.events.AdInstanceEvent;
    import com.sovrn.model.InitConfigVO;
    import com.sovrn.utils.Console;
    import com.sovrn.view.Canvas;

    import flash.display.DisplayObjectContainer;

    import flash.display.Sprite;

    public class AdCue extends Sprite {

        private var ads:Array;
        private var currentAd:IAdInstance;
        private var initConfig:InitConfigVO;
        private var _view:Canvas;

        public function AdCue(ads:Array) {
            this.ads = ads;
        }

        public function start(obj:InitConfigVO, view:Canvas):void {
            initConfig = obj;
            _view = view;

            loadAd();
        }

        private function loadAd():void {
            if (ads.length > 0) {

                try {
                    _view.resize(initConfig.width, initConfig.height);

                    currentAd = IAdInstance(ads[0]);
                    addListeners(currentAd);

                    currentAd.config = initConfig;
                    currentAd.view = _view;
                    currentAd.load();
                } catch (e:Error) {
                    Console.log('ad instance error: ' + e.toString());
                    next();
                }

            } else {
                dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_EMPTY));
            }
        }

        private function addListeners(ad:IAdInstance):void {
            DisplayObjectContainer(ad).addEventListener(AdInstanceEvent.AdLoaded, adReady);
            DisplayObjectContainer(ad).addEventListener(AdInstanceEvent.AdError, adError);
        }

        private function removeListeners(ad:IAdInstance):void {
            DisplayObjectContainer(ad).removeEventListener(AdInstanceEvent.AdLoaded, adReady);
            DisplayObjectContainer(ad).removeEventListener(AdInstanceEvent.AdError, adError);
        }

        private function adReady(e:AdInstanceEvent):void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_READY, {vpaid: currentAd.ad}));
        }

        private function adError(e:AdInstanceEvent):void {
            next();
        }

        public function next():void {
            removeListeners(currentAd);
            //currentAd.destroy();
            ads.splice(0, 1);
            loadAd();
        }

        public function stop():void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_COMPLETE));
        }

    }

}