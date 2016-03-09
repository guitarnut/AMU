package com.sovrn.ads {

    import com.sovrn.constants.AdSourceResult;
    import com.sovrn.constants.AdVPAIDEvents;
    import com.sovrn.constants.Config;
    import com.sovrn.events.AdCueEvent;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.InitConfigVO;
    import com.sovrn.model.MediaFileVO;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.view.Canvas;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import vpaid.VPAIDEvent;

    public class AdController extends Sprite {

        private var _impressionFired:Boolean = false;
        private var adCue:AdCue;
        private var _initConfig:InitConfigVO;
        private var adInstance:*;
        private var dispatcher:EventDispatcher;
        private var storedSetCalls:Array;
        private var trackingEvents:Object;
        private var impressions:Array;
        private var _view:Canvas;

        public function AdController():void {
            dispatcher = new EventDispatcher();
        }

        public function get impression():Boolean {
            return _impressionFired;
        }

        public function set ads(ads:Array):void {
            var vpaidCount:Number = 0;
            var videoCount:Number = 0;

            storedSetCalls = [];
            adInstance = null;

            var adCollection:Array = [];

            ads.map(function (val:AdVO, index:Number, array:Array):void {
                var ad:IAdInstance;

                // check for video files first
                val.mediaFileData.map(function (vo:MediaFileVO, voIndex:Number, voArray:Array):void {
                    if (Config.COMPATIBLE_VIDEO_MIMES.indexOf(vo.type) != -1) {
                        if (!ad) {
                            ad = new VideoAd(val);
                            videoCount++;
                        }
                    }
                });

                // check for VPAID second
                val.mediaFileData.map(function (vo:MediaFileVO, voIndex:Number, voArray:Array):void {
                    if (Config.COMPATIBLE_VPAID_MIMES.indexOf(vo.type) != -1) {
                        if (vo.apiFramework.toLocaleLowerCase() == Config.VPAID_API) {
                            if (!ad) {
                                ad = new VPAIDAd(val);
                                vpaidCount++;
                            }
                        }
                    }
                });

                if (ad) adCollection.push(ad);
            });

            Console.log('found ' + vpaidCount + ' VPAID ads and ' + +videoCount + ' video ads');
            Console.obj(ads);

            // create a new object each time
            adCue = new AdCue(adCollection);
            addListeners(adCue);
        }

        private function addListeners(cue:AdCue):void {
            cue.addEventListener(AdCueEvent.AD_CUE_READY, adLoaded);
            cue.addEventListener(AdCueEvent.AD_CUE_EMPTY, noAds);
            cue.addEventListener(AdCueEvent.AD_CUE_ERROR, sourceFailed);
            cue.addEventListener(AdCueEvent.AD_CUE_TIMEOUT, sourceFailed);
            cue.addEventListener(AdCueEvent.AD_CUE_IMPRESSION, adImpression);
            cue.addEventListener(AdCueEvent.AD_CUE_COMPLETE, adStopped);
        }

        private function removeListeners(cue:AdCue):void {
            cue.removeEventListener(AdCueEvent.AD_CUE_READY, adLoaded);
            cue.removeEventListener(AdCueEvent.AD_CUE_EMPTY, noAds);
            cue.removeEventListener(AdCueEvent.AD_CUE_ERROR, sourceFailed);
            cue.removeEventListener(AdCueEvent.AD_CUE_TIMEOUT, sourceFailed);
            cue.removeEventListener(AdCueEvent.AD_CUE_IMPRESSION, adImpression);
            cue.removeEventListener(AdCueEvent.AD_CUE_COMPLETE, adStopped);
        }

        public function set view(val:Canvas):void {
            _view = val;
        }

        public function set initConfig(obj:Object):void {
            _initConfig = new InitConfigVO();
            _initConfig.width = obj.width;
            _initConfig.height = obj.height;
            _initConfig.viewMode = obj.viewMode;
            _initConfig.desiredBitrate = obj.desiredBitrate;
            _initConfig.creativeData = obj.creativeData;
            _initConfig.environmentVars = obj.environmentVars;
        }

        public function get adEventDispatcher():EventDispatcher {
            return dispatcher;
        }

        /* ------------------------
         ad instance events handling
         ------------------------ */

        // these are the vpaid events we will allow to bubble up
        private function addAdEvents():void {
            AdVPAIDEvents.ALLOWED_EVENTS.map(function (val:String, index:Number, array:Array):void {
                adInstance.addEventListener(val, dispatchAdEvent);
            });

            AdVPAIDEvents.BLOCKED_EVENTS.map(function (val:String, index:Number, array:Array):void {
                adInstance.addEventListener(val, handleAdEvent);
            });
        }

        private function removeAdEvents():void {
            if (adInstance) {
                AdVPAIDEvents.ALLOWED_EVENTS.map(function (val:String, index:Number, array:Array):void {
                    adInstance.removeEventListener(val, dispatchAdEvent);
                });

                AdVPAIDEvents.BLOCKED_EVENTS.map(function (val:String, index:Number, array:Array):void {
                    adInstance.removeEventListener(val, handleAdEvent);
                });
            }
        }

        private function dispatchAdEvent(e:Event):void {
            dispatcher.dispatchEvent(new VPAIDEvent(e.type));
            handleAdEvent(e);
        }

        private function handleAdEvent(e:Event):void {
            trackEvent(e.type);
        }

        /* ------------------------
         tracking pixel handling
         ------------------------ */

        private function trackEvent(event:String):void {
            switch (event) {
                case VPAIDEvent.AdImpression:
                    // these events must always exist
                    firePixels(impressions, event);
                    break;
                case VPAIDEvent.AdStarted:
                    if (trackingEvents.hasOwnProperty('start')) firePixels(trackingEvents.start, event);
                    if (trackingEvents.hasOwnProperty('creativeView')) firePixels(trackingEvents.start, event);
                    break;
                case VPAIDEvent.AdVideoFirstQuartile:
                    if (trackingEvents.hasOwnProperty('firstQuartile')) firePixels(trackingEvents.start, event);
                    break;
                case VPAIDEvent.AdVideoMidpoint:
                    if (trackingEvents.hasOwnProperty('midpoint')) firePixels(trackingEvents.start, event);
                    break;
                case VPAIDEvent.AdVideoThirdQuartile:
                    if (trackingEvents.hasOwnProperty('thirdQuartile')) firePixels(trackingEvents.start, event);
                    break;
                case VPAIDEvent.AdVideoComplete:
                    if (trackingEvents.hasOwnProperty('complete')) firePixels(trackingEvents.start, event);
                    break;
                case VPAIDEvent.AdPaused:
                    if (trackingEvents.hasOwnProperty('pause')) firePixels(trackingEvents.start, event);
                    break;
                case VPAIDEvent.AdPlaying:
                    if (trackingEvents.hasOwnProperty('resume')) firePixels(trackingEvents.start, event);
                    break;
                case VPAIDEvent.AdUserAcceptInvitation:
                    if (trackingEvents.hasOwnProperty('acceptInvitation')) firePixels(trackingEvents.start, event);
                    break;
                // missing: mute, unmute, fullscreen, rewind
            }
        }

        private function firePixels(pixels:Array, event:String):void {
            for (var i:Number = 0, len:Number = pixels.length; i < len; i++) {
                if (i < Config.TRACKING_PIXEL_LIMIT) {
                    Console.log(pixels[0]);
                    new URLLoader().load(new URLRequest(pixels[0]));
                } else {
                    Console.log('pixel limit reached for event ' + event);
                    break;
                }
            }
        }

        /* ------------------------
         ad instance control
         ------------------------ */

        public function loadAd():void {
            adCue.start(_initConfig, _view);
        }

        public function callAdMethod(method:String, arguments:Array = null, defaultValue:* = null, property:String = ""):* {
            arguments = arguments || [];

            if (!adInstance) {
                if (property == 'get') {
                    storedSetCalls.push({
                        method: method,
                        arguments: [arguments[0]]
                    })
                }
            }

            if (adInstance) {
                try {
                    switch (property) {
                        case 'get':
                            //Console.log('get');
                            return adInstance[method];
                            break;
                        case 'set':
                            //Console.log('set');
                            adInstance[method] = arguments[0];
                            break;
                        default:
                            //Console.log('default');
                            adInstance[method].apply(adInstance, arguments);
                            break;
                    }
                } catch (e:Error) {
                    Console.log('error: ' + e.toString());
                    if (defaultValue) return defaultValue;
                }
            } else {
                Console.log('no ad, returning default: ' + defaultValue);
                if (defaultValue != null) return defaultValue;
            }
        }

        public function stop():void {
            removeAdEvents();
            adCue.stop();
        }

        /* ------------------------
         ad cue event handling
         ------------------------ */

        private function adLoaded(e:AdCueEvent):void {
            adInstance = e.data.vpaid;
            trackingEvents = e.data.ad_data.trackingEvents;
            impressions = e.data.ad_data.impressions;

            addAdEvents();
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLoaded));
        }

        private function noAds(e:AdCueEvent):void {
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError));
        }

        private function sourceFailed(e:AdCueEvent):void {
            var result:String = "";

            switch (e.type) {
                case AdCueEvent.AD_CUE_ERROR:
                    result = AdSourceResult.ERROR;
                    break;
                case AdCueEvent.AD_CUE_TIMEOUT:
                    result = AdSourceResult.TIMEOUT;
                    break;
            }

            logSourceResult(result, e.data.ad_data);
            waterfall();
        }

        private function adImpression(e:AdCueEvent):void {
            _impressionFired = true;
            Log.msg(Log.AD_IMPRESSION);
            logSourceResult(AdSourceResult.IMPRESSION, e.data.ad_data);
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression));
        }

        private function adStopped(e:AdCueEvent):void {
            stop();
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped));
        }

        private function waterfall():void {
            adCue.next();
        }

        /* ------------------------
         ad instance result logging
         ------------------------ */

        private function logSourceResult(event:String, data:AdVO):void {
            Console.log(event + ", " + data.campaignId);
        }

        /* ------------------------
         reset state
         ------------------------ */

        public function reset():void {
            stop();
            removeListeners(adCue);

            _impressionFired = false;
            adCue = null;
            adInstance = null;
            trackingEvents = null;
            impressions = null;
            storedSetCalls = [];
        }

    }

}