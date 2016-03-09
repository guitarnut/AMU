package com.sovrn.ads {

    import com.sovrn.constants.AdTypes;
    import com.sovrn.constants.Config;
    import com.sovrn.constants.Errors;
    import com.sovrn.events.AdInstanceEvent;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.InitConfigVO;
    import com.sovrn.model.MediaFileVO;
    import com.sovrn.net.FileRequest;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.Timeouts;
    import com.sovrn.view.Canvas;

    import flash.display.Sprite;
    import flash.events.Event;

    import vpaid.VPAIDEvent;

    public class VPAIDAd extends Sprite implements IAdInstance {

        private static const AD_TYPE:String = AdTypes.VPAID;
        private var _ad:*;
        private var _data:AdVO;
        private var _mediaFileVOs:Array;
        private var _mediaFile:MediaFileVO;
        private var _config:InitConfigVO;
        private var _view:Canvas;
        private var adObject:*;
        private var adLoader:FileRequest;

        public function VPAIDAd(data:AdVO):void {
            _data = data;
            _mediaFileVOs = data.mediaFileData;
        }

        /* ------------------------
         ad instance setup
         ------------------------ */

        public function load():void {
            Timeouts.start(Timeouts.LOAD_AD, adTimeout, this, [Errors.LOAD_ADMANAGER_TIMEOUT]);

            _mediaFileVOs.map(function (val:MediaFileVO, index:Number, array:Array):void {
                if ((val.apiFramework.toLowerCase() == Config.VPAID_API) && (Config.COMPATIBLE_VPAID_MIMES.indexOf(val.type)) != -1) {
                    if (!_mediaFile) {
                        _mediaFile = val;
                    }
                }
            });

            if (_mediaFile) {
                Console.log('loading ' + _mediaFile.mediaFile);

                adLoader = new FileRequest(_mediaFile.mediaFile);
                adLoader.addEventListener(Event.COMPLETE, adLoaded);
                adLoader.sendRequest();
            } else {
                handleVPAIDEvent(new VPAIDEvent(VPAIDEvent.AdError));
            }
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

        private function adLoaded(e:Event):void {
            e.stopImmediatePropagation();

            Timeouts.stop(Timeouts.LOAD_AD);
            Timeouts.start(Timeouts.AD_SESSION, adTimeout, this, [Errors.VPAID_TIMEOUT]);

            adObject = adLoader.data;
            adObject.x = 0;
            adObject.y = 0;

            _view.addChild(adObject);

            if (adObject.hasOwnProperty('getVPAID')) {
                Console.log(adObject.toString() + ' VPAID found');
                _ad = adObject.getVPAID();
            } else {
                Console.log(adObject.toString() + ' found');
                _ad = adObject;
            }

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

        /* ------------------------
         remove instance
         ------------------------ */

        public function destroy():void {
            _view.removeChild(adObject);
            removeVPAIDEvents(_ad);
            adLoader.cancel();
            _ad = null;
            adObject = null;
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