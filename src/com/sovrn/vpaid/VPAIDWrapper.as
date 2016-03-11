package com.sovrn.vpaid {

    import com.sovrn.ads.AdController;
    import com.sovrn.constants.AdVPAIDEvents;
    import com.sovrn.constants.Config;
    import com.sovrn.constants.Errors;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.Timeouts;

    import flash.display.Sprite;
    import flash.events.Event;
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

        /* ----------------------------------------- */
        // custom methods
        /* ----------------------------------------- */

        public function set controller(obj:AdController):void {
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

        private function dispatchAdEvent(e:Event):void {
            e.stopImmediatePropagation();

            if (!VPAIDState.eventFired(e.type)) {
                dispatchEvent(new VPAIDEvent(e.type));
                showEvent(e.type);
            } else {
                Console.log('blocked duplicate event ' + e.type);
            }

        }

        private function showEvent(e:String):void {
            if (VPAIDEvent.DONT_LOG.indexOf(e) == -1)Console.log('VPAIDEvent: ' + e);
        }

        private function handleAdControllerEvent(e:Event):void {
            e.stopImmediatePropagation();
            Console.log('controller: ' + e.type);

            switch (e.type) {
                case VPAIDEvent.AdError:
                    Log.msg(Log.AD_ERROR);
                    Timeouts.start(Timeouts.DESTROY, dispatchFinalEvent, this, [VPAIDEvent.AdError]);
                    break;
                case VPAIDEvent.AdLoaded:
                    Log.msg(Log.AD_LOADED);
                    Timeouts.stop(Timeouts.AD_MANAGER_SESSION);
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLoaded));
                    showEvent(VPAIDEvent.AdLoaded);
                    break;
                case VPAIDEvent.AdStopped:
                    Timeouts.start(Timeouts.DESTROY, dispatchFinalEvent, this, [VPAIDEvent.AdStopped]);
                    break;
                case VPAIDEvent.AdImpression:
                    Timeouts.stop(Timeouts.AD_MANAGER_SESSION);
                        Log.msg(Log.AD_IMPRESSION);
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression));
                    showEvent(VPAIDEvent.AdImpression);
                    break;
            }
        }

        // this ends the session
        public function fireAdError(error:Number = 0):void {
            switch (error) {
                case Errors.ADDELIVERY_TIMEOUT:
                    Log.msg(Log.AD_DELIVERY_TIMEOUT);
                    break;
                case Errors.IO_ERROR:
                    Log.msg(Log.IO_ERROR);
                    break;
            }

            Timeouts.start(Timeouts.DESTROY, dispatchFinalEvent, this, [VPAIDEvent.AdError]);
        }

        // this should be the only place in the code AdStopped and AdError can propogate from
        private function dispatchFinalEvent(e:String):void {
            showEvent(e);
            dispatchEvent(new VPAIDEvent(e));
        }

        public function getVPAID():* {
            Console.log('getVPAID() called');
            return this;
        }

        /* ----------------------------------------- */
        // IVPAID methods
        /* ----------------------------------------- */

        public function handshakeVersion(playerVPAIDVersion:String):String {
            Console.log('handshakeVersion');
            return "1.0";
        }

        public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String = "", environmentVars:String = ""):void {
            Console.log('initAd');
            Timeouts.start(Timeouts.AD_MANAGER_SESSION, fireAdError, this, []);
            dispatchEvent(new AdManagerEvent(AdManagerEvent.INIT_AD_CALLED, {
                width: width,
                height: height,
                viewMode: viewMode,
                desiredBitrate: desiredBitrate,
                creativeData: creativeData,
                environmentVars: environmentVars
            }));

            VPAIDState.initAd();
        }

        /* ------ getters / setters ----------------------------------------- */

        public function get adLinear():Boolean {
            Console.log('adLinear');
            return _adController.callAdMethod('adLinear', [], true, 'get');
        }

        public function get adExpanded():Boolean {
            Console.log('adExpanded');
            return _adController.callAdMethod('adExpanded', [], false, 'get');
        }

        public function get adRemainingTime():Number {
            //Console.log('adRemainingTime');
            return _adController.callAdMethod('adRemainingTime', [], -2, 'get');
        }

        public function get adVolume():Number {
            Console.log('adVolume');
            return Number(_adController.callAdMethod('adVolume', [], '0', 'get'));
        }

        public function set adVolume(val:Number):void {
            Console.log('adVolume: ' + val);
            VPAIDState.volume = val;
            _adController.callAdMethod('adVolume', [val], null, 'set');
        }

        /* ------ layout methods ----------------------------------------- */

        public function resizeAd(w:Number, h:Number, viewMode:String):void {
            Console.log('resizeAd');
            _adController.callAdMethod('resizeAd', [w, h, viewMode]);
        }

        /* ------  control methods ----------------------------------------- */

        public function expandAd():void {
            Console.log('expandAd');
            _adController.callAdMethod('expandAd');
        }

        public function collapseAd():void {
            Console.log('collapseAd');
            _adController.callAdMethod('collapseAd');
        }

        public function startAd():void {
            Console.log('startAd');

            if (VPAIDState.AdLoadedFired) {
                Timeouts.start(Timeouts.AD_MANAGER_SESSION, fireAdError, this, []);
                _adController.callAdMethod('startAd');
            } else {
                Log.custom({
                    vpaidEvent: 'AdLog',
                    vpaidEventData: 'startAd called before AdLoaded fired'
                });

                fireAdError();
            }
        }

        public function stopAd():void {
            Console.log('stopAd');
            _adController.callAdMethod('stopAd');
            _adController.stop();

            Timeouts.start(Timeouts.DESTROY, dispatchFinalEvent, this, [VPAIDEvent.AdStopped]);
        }

        public function pauseAd():void {
            Console.log('pauseAd');
            _adController.callAdMethod('pauseAd');
        }

        public function resumeAd():void {
            Console.log('resumeAd');
            _adController.callAdMethod('resumeAd');
        }

        /* --------------------------- */
        /* ------  VPAID 2.0 methods ----------------------------------------- */
        /* --------------------------- */

        public function skipAd():void {
            Console.log('skipAd');
            _adController.callAdMethod('skipAd');
        }

        public function get adWidth():Number {
            Console.log('adWidth');
            return Number(_adController.callAdMethod('adWidth', [], '0', 'get'));
        }

        public function get adHeight():Number {
            Console.log('adHeight');
            return Number(_adController.callAdMethod('adHeight', [], '0', 'get'));
        }

        public function get adIcons():Boolean {
            Console.log('adIcons');
            return _adController.callAdMethod('adIcons', [], false, 'get');
        }

        public function get adSkippableState():Boolean {
            Console.log('adSkippableState');
            return _adController.callAdMethod('adSkippableState', [], false, 'get');
        }

        public function get adDuration():Number {
            Console.log('adDuration');
            return _adController.callAdMethod('adDuration', [], -2, 'get');
        }

        public function get adCompanions():String {
            Console.log('adCompanions');
            return _adController.callAdMethod('adCompanions', [], " ", 'get');
        }
    }
}
