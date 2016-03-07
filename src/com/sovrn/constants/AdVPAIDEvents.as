package com.sovrn.constants {

    import vpaid.VPAIDEvent;

    public class AdVPAIDEvents {

        public static const ALLOWED_EVENTS:Array = [
            // VPAIDEvent.AdLoaded,
            VPAIDEvent.AdStarted,
            // VPAIDEvent.AdStopped,
            // VPAIDEvent.AdSkipped,
            VPAIDEvent.AdLinearChange,
            VPAIDEvent.AdExpandedChange,
            VPAIDEvent.AdRemainingTimeChange,
            VPAIDEvent.AdVolumeChange,
            VPAIDEvent.AdImpression,
            VPAIDEvent.AdVideoStart,
            VPAIDEvent.AdVideoFirstQuartile,
            VPAIDEvent.AdVideoMidpoint,
            VPAIDEvent.AdVideoThirdQuartile,
            VPAIDEvent.AdVideoComplete,
            VPAIDEvent.AdClickThru,
            // VPAIDEvent.AdUserAcceptInvitation,
            VPAIDEvent.AdUserMinimize,
            VPAIDEvent.AdUserClose,
            VPAIDEvent.AdPaused,
            VPAIDEvent.AdPlaying,
            VPAIDEvent.AdLog,
            // VPAIDEvent.AdError,
            VPAIDEvent.AdSizeChange,
            VPAIDEvent.AdSkippableStateChange,
            VPAIDEvent.AdDurationChange,
            VPAIDEvent.AdInteraction
        ];

        public static const BLOCKED_EVENTS:Array = [
            VPAIDEvent.AdLoaded,
            VPAIDEvent.AdStopped,
            VPAIDEvent.AdSkipped,
            VPAIDEvent.AdUserAcceptInvitation,
            VPAIDEvent.AdError
        ];
    }

}