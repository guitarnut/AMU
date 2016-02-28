package com.sovrn.vpaid {

    import com.sovrn.ads.AdController;
    import com.sovrn.constants.AdVPAIDEvents;
    import com.sovrn.constants.Config;
    import com.sovrn.events.AdManagerEvent;

    import flash.display.Sprite;
    import flash.events.EventDispatcher;

    import vpaid.IVPAID;
    import vpaid.VPAIDEvent;

    /*

    The VPAID Wrapper does not know or care if an ad is available. It relays method calls from the video player
    to the ad controller and passes on approved VPAID events from the event dispatcher when it receives them.
    No state is maintained in this class. It receives a single instance of the ad controller and the
    ad controller's event dispatcher.

    */

    public class VPAIDWrapper extends Sprite implements IVPAID {

        private var _adController:AdController;
        private var adEvents:EventDispatcher;

        public function VPAIDWrapper() {
        }

        // custom methods

        public function set adController(obj:AdController):void {
            _adController = obj;
            adEvents = _adController.adEventDispatcher;
            addControllerListeners();
            addDispatcherListeners();
        }

        private function addControllerListeners():void {
            _adController.addEventListener(VPAIDEvent.AdLoaded, handleAdControllerEvent);
            _adController.addEventListener(VPAIDEvent.AdImpression, handleAdControllerEvent);
            _adController.addEventListener(VPAIDEvent.AdError, handleAdControllerEvent);
            _adController.addEventListener(VPAIDEvent.AdStopped, handleAdControllerEvent);
        }

        private function addDispatcherListeners():void {
            AdVPAIDEvents.ALLOWED_EVENTS.map(function (val:String, index:Number, array:Array):void {
                adEvents.addEventListener(val, dispatchAdEvent);
            });
        }

        private function dispatchAdEvent(e:VPAIDEvent):void {
            dispatchEvent(new VPAIDEvent(e.type));
        }

        private function handleAdControllerEvent(e:VPAIDEvent):void {
            e.stopImmediatePropagation();

            switch (e.type) {
                case VPAIDEvent.AdError:
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError));
                    break;
                case VPAIDEvent.AdLoaded:
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLoaded));
                    break;
                case VPAIDEvent.AdImpression:
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression));
                    break;
                case VPAIDEvent.AdStopped:
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped));
                    break;
            }
        }

        // this ends the session
        public function adError():void {
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError));
        }

        // IVPAID methods

        public function handshakeVersion(playerVPAIDVersion:String):String {
            return Config.VPAID_VERSION;
        }

        public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String = "", environmentVars:String = ""):void {
            dispatchEvent(new AdManagerEvent(AdManagerEvent.INIT_AD_CALLED, {
                width: width,
                height: height,
                viewMode: viewMode,
                desiredBitrate: desiredBitrate,
                creativeData: creativeData,
                environmentVars: environmentVars
            }));
        }

        /* ------ getters / setters ----------------------------------------- */

        public function get adLinear():Boolean {
            return _adController.callAdMethod('adLinear', [], true, 'get');
        }

        public function get adExpanded():Boolean {
            return _adController.callAdMethod('adExpanded', [], false, 'get');
        }

        public function get adRemainingTime():Number {
            return _adController.callAdMethod('adRemainingTime', [], -2, 'get');
        }

        public function get adVolume():Number {
            return Number(_adController.callAdMethod('adVolume', [], '0', 'get'));
        }

        public function set adVolume(val:Number):void {
            _adController.callAdMethod('adVolume', [val], null, 'set');
        }

        /* ------ layout methods ----------------------------------------- */

        public function resizeAd(w:Number, h:Number, viewMode:String):void {
            _adController.callAdMethod('resizeAd', [w, h, viewMode]);
        }

        /* ------  control methods ----------------------------------------- */

        public function expandAd():void {
            _adController.callAdMethod('expandAd');
        }

        public function collapseAd():void {
            _adController.callAdMethod('collapseAd');
        }

        public function startAd():void {
            _adController.callAdMethod('startAd');
        }

        public function stopAd():void {
            _adController.callAdMethod('stopAd');
        }

        public function pauseAd():void {
            _adController.callAdMethod('pauseAd');
        }

        public function resumeAd():void {
            _adController.callAdMethod('resumeAd');
        }

        /* --------------------------- */
        /* ------  VPAID 2.0 methods ----------------------------------------- */
        /* --------------------------- */

        public function skipAd():void {
            _adController.callAdMethod('skipAd');
        }

        public function get adWidth():Number {
            return Number(_adController.callAdMethod('adWidth', [], '0', 'get'));
        }

        public function get adHeight():Number {
            return Number(_adController.callAdMethod('adHeight', [], '0', 'get'));
        }

        public function get adIcons():Boolean {
            return _adController.callAdMethod('adIcons', [], false, 'get');
        }

        public function get adSkippableState():Boolean {
            return _adController.callAdMethod('adSkippableState', [], false, 'get');
        }

        public function get adDuration():Number {
            return _adController.callAdMethod('adDuration', [], -2, 'get');
        }

        public function get adCompanions():String {
            return _adController.callAdMethod('adCompanions', [], " ", 'get');
        }
    }
}
