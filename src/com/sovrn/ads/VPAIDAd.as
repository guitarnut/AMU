package com.sovrn.ads {

    import com.sovrn.constants.AdTypes;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.InitConfigVO;
    import com.sovrn.net.FileRequest;
    import com.sovrn.utils.Console;

    import flash.display.DisplayObjectContainer;

    import flash.display.Sprite;

    import flash.events.Event;

    import vpaid.IVPAID;

    import vpaid.VPAIDEvent;

    public class VPAIDAd extends Sprite implements IAdInstance {

        private static const AD_TYPE:String = AdTypes.VPAID;
        private var _ad:*;
        private var _data:AdVO;
        private var _config:InitConfigVO;
        private var _view:DisplayObjectContainer;
        private var adLoader:FileRequest;

        public function VPAIDAd(data:AdVO):void {
            _data = data;
        }

        public function load():void {
            adLoader = new FileRequest(_data.mediaFiles[0].MediaFile);
            adLoader.addEventListener(Event.COMPLETE, adLoaded);
            adLoader.sendRequest();
        }

        private function adLoaded(e:Event):void {
            _ad = adLoader.data.getVPAID() || adLoader.data;
            _view.addChild(_ad);
            addVPAIDEvents(_ad);
            initAd();
        }

        private function addVPAIDEvents(adInstance:*):void {
            _ad.addEventListener(VPAIDEvent.AdLoaded, handleVPAIDEvent);
            _ad.addEventListener(VPAIDEvent.AdError, handleVPAIDEvent);
        }

        private function removeVPAIDEvents(adInstance:*):void {
            _ad.removeEventListener(VPAIDEvent.AdLoaded, handleVPAIDEvent);
            _ad.removeEventListener(VPAIDEvent.AdError, handleVPAIDEvent);
        }

        private function initAd():void {
            _ad.initAd(
                    _config.width,
                    _config.height,
                    _config.viewMode,
                    _config.desiredBitrate,
                    _data.adParameters,
                    _config.environmentVars
            );
        }

        private function handleVPAIDEvent(e:VPAIDEvent):void {
            Console.log('VPAID Ad: ' + e.type);

            switch (e.type) {
                case VPAIDEvent.AdLoaded:
                    break;
                case VPAIDEvent.AdError:
                    break;
                default:
                    break;
            }
        }

        public function destroy():void {
            adLoader.cancel();
            removeVPAIDEvents(_ad);
            _view.removeChild(_ad);
            _ad = null;
        }

        public function set config(initConfig:InitConfigVO):void {
            _config = initConfig;
        }

        public function set view(val:DisplayObjectContainer):void {
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