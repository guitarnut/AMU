package vpaid {

    import com.sovrn.utils.Console;

    import flash.events.Event;

    public class VPAIDEvent extends Event {
        public static const AdLoaded:String = "AdLoaded";
        public static const AdStarted:String = "AdStarted";
        public static const AdStopped:String = "AdStopped";
        public static const AdSkipped:String = "AdSkipped";
        public static const AdLinearChange:String = "AdLinearChange";
        public static const AdExpandedChange:String = "AdExpandedChange";
        public static const AdRemainingTimeChange:String = "AdRemainingTimeChange";
        public static const AdVolumeChange:String = "AdVolumeChange";
        public static const AdImpression:String = "AdImpression";
        public static const AdVideoStart:String = "AdVideoStart";
        public static const AdVideoFirstQuartile:String = "AdVideoFirstQuartile";
        public static const AdVideoMidpoint:String = "AdVideoMidpoint";
        public static const AdVideoThirdQuartile:String = "AdVideoThirdQuartile";
        public static const AdVideoComplete:String = "AdVideoComplete";
        public static const AdClickThru:String = "AdClickThru";
        public static const AdUserAcceptInvitation:String = "AdUserAcceptInvitation";
        public static const AdUserMinimize:String = "AdUserMinimize";
        public static const AdUserClose:String = "AdUserClose";
        public static const AdPaused:String = "AdPaused";
        public static const AdPlaying:String = "AdPlaying";
        public static const AdLog:String = "AdLog";
        public static const AdError:String = "AdError";

        /* -- VPAID 2.0 Events -- */
        public static const AdSizeChange:String = "AdSizeChange";
        public static const AdSkippableStateChange:String = "AdSkippableStateChange";
        public static const AdDurationChange:String = "AdDurationChange";
        public static const AdInteraction:String = "AdInteraction";

        /* -- Custom Events -- */
        public static const AdHandshake:String = "AdHandshake";
        public static const AdInit:String = "AdInit";
        public static const AdManagerInitComplete:String = "AdManagerInitComplete";
        public static const AdDeliveryRequest:String = "AdDeliveryRequest";
        public static const AdDeliveryRequestComplete:String = "AdDeliveryRequestComplete";
        public static const SWFLoaded:String = "SWFLoaded";
        public static const ModuleLoaded:String = "ModuleLoaded";
        public static const ModuleReused:String = "ModuleReused";
        public static const CreativePassback:String = "CreativePassback";
        public static const VPAIDTransactionFailed:String = "VPAIDTransactionFailed";
        public static const AdSourceResult:String = "AdSourceResult";
        public static const AdTimeout:String = "AdTimeout";
        public static const BeaconFailed:String = "BeaconFailed";

        public static const DONT_LOG:Array = [VPAIDEvent.AdRemainingTimeChange];

        public var _data:Object;

        public function VPAIDEvent(eventType:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false) {
            super(eventType, bubbles, cancelable);

            _data = data;
        }

        public function get data():Object {
            return _data;
        }
    }
}