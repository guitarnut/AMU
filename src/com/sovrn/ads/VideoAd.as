package com.sovrn.ads {

    import com.sovrn.constants.AdTypes;
    import com.sovrn.constants.Errors;
    import com.sovrn.events.AdInstanceEvent;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.InitConfigVO;
    import com.sovrn.model.MediaFileVO;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.Timeouts;
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

        private function adTimeout(error:Number):void {
            switch (error) {
                case Errors.LOAD_ADMANAGER_TIMEOUT:
                    Log.msg(Log.MEDIA_FILE_LOAD_TIMEOUT);
                    break;
                case Errors.VPAID_TIMEOUT:
                    Log.msg(Log.AD_VPAID_TIMEOUT);
                    break;
            }

            dispatchEvent(new AdInstanceEvent(AdInstanceEvent.AdTimeout));
        }

        private function addVPAIDEvents(adInstance:*):void {
            try {
                adInstance.addEventListener(VPAIDEvent.AdLoaded, handleAdEvent);
                adInstance.addEventListener(VPAIDEvent.AdError, handleAdEvent);
                adInstance.addEventListener(VPAIDEvent.AdStopped, handleAdEvent);
                adInstance.addEventListener(VPAIDEvent.AdImpression, handleAdEvent);
                adInstance.addEventListener(AdInstanceEvent.AdTimeout, handleAdEvent);
            } catch (e:Error) {
                Console.log(e.toString());
            }
        }

        private function removeVPAIDEvents(adInstance:*):void {
            try {
                adInstance.removeEventListener(VPAIDEvent.AdLoaded, handleAdEvent);
                adInstance.removeEventListener(VPAIDEvent.AdError, handleAdEvent);
                adInstance.removeEventListener(VPAIDEvent.AdStopped, handleAdEvent);
                adInstance.removeEventListener(VPAIDEvent.AdImpression, handleAdEvent);
                adInstance.removeEventListener(AdInstanceEvent.AdTimeout, handleAdEvent);
            } catch (e:Error) {
                Console.log(e.toString());
            }
        }

        /* ------------------------
         vpaid
         ------------------------ */

        private function initAd():void {
            Timeouts.start(Timeouts.AD_SESSION, adTimeout, this, [Errors.VPAID_TIMEOUT]);

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
                handleAdEvent(new VPAIDEvent(VPAIDEvent.AdError));
            }
        }

        private function handleAdEvent(e:Event):void {
            e.stopImmediatePropagation();

            Console.log('VPAID Ad Fired Event: ' + e.type);

            switch (e.type) {
                case VPAIDEvent.AdLoaded:
                    Timeouts.stop(Timeouts.AD_SESSION);
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