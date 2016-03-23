package com.sovrn.vpaid {

    import com.sovrn.ads.AdController;
    import com.sovrn.constants.AdVPAIDEvents;
    import com.sovrn.constants.Config;
    import com.sovrn.constants.Errors;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.Timeouts;
    import com.sovrn.vpaid.VPAIDState;
    import com.sovrn.vpaid.VPAIDState;

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
            dispatchVPAIDEvent(e.type);
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
                    dispatchVPAIDEvent(VPAIDEvent.AdLoaded);

                    if (VPAIDState.AdLoadedFired) {
                        Log.msg('trying next ad source');
                        startAd();
                    } else {
                        VPAIDState.AdLoaded();
                        Timeouts.stop(Timeouts.AD_MANAGER_SESSION);
                    }
                    break;
                case VPAIDEvent.AdStopped:
                    Timeouts.start(Timeouts.DESTROY, dispatchFinalEvent, this, [VPAIDEvent.AdStopped]);
                    break;
                case VPAIDEvent.AdImpression:
                    Timeouts.stop(Timeouts.AD_MANAGER_SESSION);
                    Log.msg(Log.AD_IMPRESSION);
                    dispatchVPAIDEvent(VPAIDEvent.AdImpression);
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

        private function dispatchVPAIDEvent(event:String):void {
            if (!VPAIDState.eventFired(event)) {
                dispatchEvent(new VPAIDEvent(event));
                showEvent(event);
            } else {
                Console.log('blocked duplicate event ' + event);
            }
        }

        // this should be the only place in the code AdStopped and AdError can propogate from
        private function dispatchFinalEvent(e:String):void {
            dispatchVPAIDEvent(e);
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
            Console.log('video player called initAd');
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
            Console.log('video player called get adLinear');
            return _adController.callAdMethod('adLinear', [], true, 'get');
        }

        public function get adExpanded():Boolean {
            Console.log('video player called get adExpanded');
            return _adController.callAdMethod('adExpanded', [], false, 'get');
        }

        public function get adRemainingTime():Number {
            //Console.log('adRemainingTime');
            return _adController.callAdMethod('adRemainingTime', [], -2, 'get');
        }

        public function get adVolume():Number {
            Console.log('video player called get adVolume');
            return Number(_adController.callAdMethod('adVolume', [], '0', 'get'));
        }

        public function set adVolume(val:Number):void {
            Console.log('video player called set adVolume: ' + val);
            VPAIDState.volume = val;
            _adController.callAdMethod('adVolume', [val], null, 'set');
        }

        /* ------ layout methods ----------------------------------------- */

        public function resizeAd(w:Number, h:Number, viewMode:String):void {
            Console.log('video player called resizeAd: ' + w + ', ' + h);
            _adController.callAdMethod('resizeAd', [w, h, viewMode]);
        }

        /* ------  control methods ----------------------------------------- */

        public function expandAd():void {
            Console.log('video player called expandAd');
            _adController.callAdMethod('expandAd');
        }

        public function collapseAd():void {
            Console.log('video player called collapseAd');
            _adController.callAdMethod('collapseAd');
        }

        public function startAd():void {
            Console.log('video player called startAd');

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
            Console.log('video player called stopAd');
            _adController.callAdMethod('stopAd');
            _adController.stop();

            Timeouts.start(Timeouts.DESTROY, dispatchFinalEvent, this, [VPAIDEvent.AdStopped]);
        }

        public function pauseAd():void {
            Console.log('video player called pauseAd');
            _adController.callAdMethod('pauseAd');
        }

        public function resumeAd():void {
            Console.log('video player called resumeAd');
            _adController.callAdMethod('resumeAd');
        }

        /* --------------------------- */
        /* ------  VPAID 2.0 methods ----------------------------------------- */
        /* --------------------------- */

        public function skipAd():void {
            Console.log('video player called skipAd');
            _adController.callAdMethod('skipAd');
        }

        public function get adWidth():Number {
            Console.log('video player called get adWidth');
            return Number(_adController.callAdMethod('adWidth', [], '0', 'get'));
        }

        public function get adHeight():Number {
            Console.log('video player called get adHeight');
            return Number(_adController.callAdMethod('adHeight', [], '0', 'get'));
        }

        public function get adIcons():Boolean {
            Console.log('video player called get adIcons');
            return _adController.callAdMethod('adIcons', [], false, 'get');
        }

        public function get adSkippableState():Boolean {
            Console.log('video player called get adSkippableState');
            return _adController.callAdMethod('adSkippableState', [], false, 'get');
        }

        public function get adDuration():Number {
            Console.log('video player called get adDuration');
            return _adController.callAdMethod('adDuration', [], -2, 'get');
        }

        public function get adCompanions():String {
            Console.log('video player called get adCompanions');
            return _adController.callAdMethod('adCompanions', [], " ", 'get');
        }
    }
}
