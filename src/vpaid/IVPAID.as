package vpaid {

    /* all VPAID 2.0 methods and properties */

    public interface IVPAID {
        // Getters
        function get adLinear():Boolean;

        function get adExpanded():Boolean;

        function get adRemainingTime():Number;

        function get adVolume():Number;

        // Methods
        function handshakeVersion(playerVPAIDVersion:String):String;

        function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String = "", environmentVars:String = ""):void;

        function resizeAd(w:Number, h:Number, viewMode:String):void;

        function startAd():void;

        function stopAd():void;

        function pauseAd():void;

        function resumeAd():void;

        function expandAd():void;

        function collapseAd():void;

        // 2.0 Methods
        function get adWidth():Number;

        function get adHeight():Number;

        function get adIcons():Boolean;

        function get adSkippableState():Boolean;

        function get adDuration():Number;

        function get adCompanions():String;

        function skipAd():void;

    }
}