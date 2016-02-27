package com.sovrn.ads {
    import com.sovrn.constants.Config;

    import flash.display.Sprite;

    public class AdCall extends Sprite {

        private static const VIDEO_MIMES:Array = ['video/mp4','application/shockwave-x'];
        private static const PROTOCOLS:Array = [];
        private var config:Object;

        public function AdCall(config:Object) {
            this.config = config;
        }

        private function buildURI():String {
            var uri:String = "";
            uri += config.server;
            uri += "/" + Config.ENDPOINT_ADS;
            uri += "?";

            return uri;
        }

    }

}