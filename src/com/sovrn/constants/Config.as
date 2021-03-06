package com.sovrn.constants {

    public class Config {
        public static const APP_NAME:String = "flash_v3";

        public static const VPAID_VERSION:String = "2.0";

        public static const SERVER:String = "ap.lijit.com";

        public static const ENDPOINT_LOG:String = "vlog";

        public static const ENDPOINT_ADS:String = "addelivery";

        public static const ENDPOINT_IMPRESSIONS:String = "impressions";

        public static const WRAPPER_LIMIT:int = 5;

        public static const TRACKING_PIXEL_LIMIT:int = 5;

        public static const SOURCE_LIMIT:int = 5;

        public static const VIDEO_BUFFER_TIME:Number = 5;

        public static const VPAID_API:String = "vpaid";

        public static const VIDEO_DELIVERY:String = "progressive";

        public static const COMPATIBLE_VIDEO_MIMES:Array = [
            'video/mp4',
            'video/flv',
            'application/vpaid',
            'application/swf'
        ];

        public static const COMPATIBLE_VPAID_MIMES:Array = [
                'application/x-shockwave-flash'
        ];

        public static const TIMEOUTS:Object = {
            AdDelivery: 3,
            Waterfall: 30,
            VASTAdTagURI: 2,
            MediaFile: 3,
            AdLoaded: 15,
            SourceSession: 12,
            Destroy: 0.5
        };

        public static const BLOCKED_PIXEL:String = "vst.php"
    }

}