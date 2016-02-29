package com.sovrn.constants {

    public class Config {
        public static const VPAID_VERSION:String = "2.0";

        public static const SERVER:String = "ap.lijit.com";

        public static const ENDPOINT_LOG:String = "vlog";

        public static const ENDPOINT_ADS:String = "addelivery";

        public static const ENDPOINT_IMPRESSIONS:String = "impressions";

        public static const WRAPPER_LIMIT:int = 5;

        public static const TRACKING_PIXEL_LIMIT:int = 5;

        public static const SOURCE_LIMIT:int = 5;

        public static const COMPATIBLE_MIMES:Array = [
            'video/mp4',
            'application/vpaid',
            'application/swf'
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
    }

}