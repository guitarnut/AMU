package com.sovrn.ads {
    import com.sovrn.constants.AdTypes;
    import com.sovrn.events.AdInstanceEvent;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.InitConfigVO;
    import com.sovrn.utils.Console;
    import com.sovrn.video.VideoController;
    import com.sovrn.view.Canvas;

    import flash.display.Sprite;
    import flash.events.Event;

    import vpaid.VPAIDEvent;

    public class VideoAd extends Sprite implements IAdInstance {

        private static const AD_TYPE:String = AdTypes.VIDEO;
        private var _ad:*;
        private var _data:AdVO;
        private var _config:InitConfigVO;
        private var _view:Canvas;
        private var video:VideoController;

        public function VideoAd(data:AdVO):void {
            _data = data;
        }

        public function load():void {
            video = new VideoController();
            video.view = _view;
            video.config = _data;

            _ad = video;

            addVPAIDEvents(_ad);
            initAd();
        }

        private function addVPAIDEvents(adInstance:*):void {
            try {
                adInstance.addEventListener(VPAIDEvent.AdLoaded, handleVPAIDEvent);
                adInstance.addEventListener(VPAIDEvent.AdError, handleVPAIDEvent);
                adInstance.addEventListener(VPAIDEvent.AdStopped, handleVPAIDEvent);
                adInstance.addEventListener(VPAIDEvent.AdImpression, handleVPAIDEvent);
            } catch (e:Error) {
                Console.log(e.toString());
            }
        }

        private function removeVPAIDEvents(adInstance:*):void {
            try {
                adInstance.removeEventListener(VPAIDEvent.AdLoaded, handleVPAIDEvent);
                adInstance.removeEventListener(VPAIDEvent.AdError, handleVPAIDEvent);
                adInstance.removeEventListener(VPAIDEvent.AdStopped, handleVPAIDEvent);
                adInstance.removeEventListener(VPAIDEvent.AdImpression, handleVPAIDEvent);
            } catch (e:Error) {
                Console.log(e.toString());
            }
        }

        /* ------------------------
         vpaid
         ------------------------ */

        private function initAd():void {
            try {
                _ad.initAd(
                        _config.width,
                        _config.height,
                        _config.viewMode,
                        _config.desiredBitrate,
                        _data.adParameters,
                        _config.environmentVars
                );
            } catch (e:Error) {
                handleVPAIDEvent(new VPAIDEvent(VPAIDEvent.AdError));
            }
        }

        private function handleVPAIDEvent(e:Event):void {
            e.stopImmediatePropagation();

            Console.log('VPAID Ad Fired Event: ' + e.type);

            switch (e.type) {
                case VPAIDEvent.AdLoaded:
                    dispatchEvent(new AdInstanceEvent(AdInstanceEvent.AdLoaded));
                    break;
                case VPAIDEvent.AdError:
                    dispatchEvent(new AdInstanceEvent(AdInstanceEvent.AdError));
                    break;
                case VPAIDEvent.AdStopped:
                    dispatchEvent(new AdInstanceEvent(AdInstanceEvent.AdStopped));
                    break;
                case VPAIDEvent.AdImpression:
                    dispatchEvent(new AdInstanceEvent(AdInstanceEvent.AdImpression));
                    break;
                default:
                    break;
            }
        }

        public function destroy():void {

        }

        public function set config(initConfig:InitConfigVO):void {
            _config = initConfig;
        }

        public function set view(val:Canvas):void {
            _view = val;
        }

        public function get ad():* {
            return _ad;
        }

        public function get adType():String {
            return AD_TYPE;
        }

        public function get data():Object {
            return _data;
        }

    }

}