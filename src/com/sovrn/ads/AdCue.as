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

        /* ------------------------
         ad instance handling
         ------------------------ */

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

        /* ------------------------
         ad instance events handling
         ------------------------ */

        private function addListeners(ad:IAdInstance):void {
            DisplayObjectContainer(ad).addEventListener(AdInstanceEvent.AdLoaded, adReady);
            DisplayObjectContainer(ad).addEventListener(AdInstanceEvent.AdError, adError);
            DisplayObjectContainer(ad).addEventListener(AdInstanceEvent.AdTimeout, adTimeout);
            DisplayObjectContainer(ad).addEventListener(AdInstanceEvent.AdStopped, adStopped);
            DisplayObjectContainer(ad).addEventListener(AdInstanceEvent.AdImpression, adImpression);
        }

        private function removeListeners(ad:IAdInstance):void {
            DisplayObjectContainer(ad).removeEventListener(AdInstanceEvent.AdLoaded, adReady);
            DisplayObjectContainer(ad).removeEventListener(AdInstanceEvent.AdError, adError);
            DisplayObjectContainer(ad).removeEventListener(AdInstanceEvent.AdTimeout, adTimeout);
            DisplayObjectContainer(ad).removeEventListener(AdInstanceEvent.AdStopped, adStopped);
            DisplayObjectContainer(ad).removeEventListener(AdInstanceEvent.AdImpression, adImpression);
        }

        private function adReady(e:AdInstanceEvent):void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_READY, {
                vpaid: currentAd.ad,
                ad_data: ads[0].data
            }));
        }

        private function adError(e:AdInstanceEvent):void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_ERROR, {
                ad_data: ads[0].data
            }));
        }

        private function adTimeout(e:AdInstanceEvent):void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_TIMEOUT, {
                ad_data: ads[0].data
            }));
        }

        private function adImpression(e:AdInstanceEvent):void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_IMPRESSION, {
                ad_data: ads[0].data
            }));
        }

        private function adStopped(e:AdInstanceEvent):void {
            dispatchEvent(new AdCueEvent(AdCueEvent.AD_CUE_COMPLETE));
        }

        /* ------------------------
         waterfall commands
         ------------------------ */

        public function next():void {
            Console.log('next source');
            removeListeners(currentAd);
            currentAd.destroy();
            ads.splice(0, 1);
            loadAd();
        }

        public function stop():void {
            if (currentAd) removeListeners(currentAd);
            ads = [];
        }

    }

}