package com.sovrn.net {

    import com.sovrn.constants.Config;
    import com.sovrn.constants.Errors;
    import com.sovrn.model.ApplicationVO;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.ObjectTools;
    import com.sovrn.utils.Stats;

    import flash.net.URLLoader;

    import flash.net.URLRequest;

    public class Log {

        public static var AD_MANAGER_INITIALIZED:String = "AD_MANAGER_INITIALIZED";
        public static var END_SESSION:String = "END_SESSION";

        public static var VIEWABILITY:String = "VIEWABILITY";

        public static var AD_DELIVERY_COMPLETE:String = "AD_DELIVERY_COMPLETE";
        public static var AD_DELIVERY_TIMEOUT:String = "AD_DELIVERY_TIMEOUT";

        public static var AD_LOADED:String = "AD_LOADED";
        public static var AD_ERROR:String = "AD_ERROR";
        public static var AD_IMPRESSION:String = "AD_IMPRESSION";

        public static var AD_SOURCE_IMPRESSION:String = "AD_SOURCE_IMPRESSION";
        public static var AD_SOURCE_ERROR:String = "AD_SOURCE_ERROR";
        public static var AD_SOURCE_TIMEOUT:String = "AD_SOURCE_TIMEOUT";

        public static var VAST_PARSE_ERROR:String = "VAST_PARSE_ERROR";

        public static var MEDIA_FILE_LOAD_TIMEOUT:String = "MEDIA_FILE_LOAD_TIMEOUT";
        public static var MEDIA_FILE_LOAD_ERROR:String = "MEDIA_FILE_LOAD_ERROR";
        public static var MEDIA_FILE_TYPE_ERROR:String = "MEDIA_FILE_TYPE_ERROR";

        public static var EXTERNAL_INTERFACE_FAIL:String = "EXTERNAL_INTERFACE_FAIL";
        public static var DOMAIN_MISMATCH:String = "DOMAIN_MISMATCH";

        public static var AD_VPAID_TIMEOUT:String = "AD_VPAID_TIMEOUT";
        public static var AD_SOURCES_TIMEOUT:String = "AD_SOURCES_TIMEOUT";
        public static var INIT_TIMEOUT:String = "INIT_TIMEOUT";

        public static var IO_ERROR:String = "IO_ERROR";

        private static var config:ApplicationVO;

        public static function init(data:ApplicationVO):void {
            config = data;
        }

        public static function msg(evt:String, data:String = ""):void {
            Console.log(evt);
            data = data || "";

            switch (evt) {
                case AD_MANAGER_INITIALIZED:
                    send(event("AdManagerInitComplete", data));
                    break;
                case AD_DELIVERY_COMPLETE:
                    send(event("AdDeliveryCallComplete", data));
                    break;
                case VIEWABILITY:
                    send(event("Viewability", data));
                    break;
                case AD_DELIVERY_TIMEOUT:
                    send(error(Errors.ADDELIVERY_TIMEOUT, data));
                    break;
                case AD_LOADED:
                    send(event("AdLoaded", data));
                    break;
                case AD_ERROR:
                    send(event("AdError", data));
                    break;
                case AD_IMPRESSION:
                    send(event("AdImpression", data));
                    break;
                case AD_SOURCE_IMPRESSION:
                    custom({
                        result: "imp",
                        vpaidEventData: data
                    });
                    break;
                case AD_SOURCE_ERROR:
                    custom({
                        result: "error",
                        vpaidEventData: data
                    });
                    break;
                case AD_SOURCE_TIMEOUT:
                    custom({
                        result: "timeout",
                        vpaidEventData: data
                    });
                    break;
                case VAST_PARSE_ERROR:
                    send(error(Errors.VAST_PARSE_ERROR, data));
                    break;
                case MEDIA_FILE_TYPE_ERROR:
                    send(error(Errors.VAST_MEDIA_FILE_ERROR, data));
                    break;
                case EXTERNAL_INTERFACE_FAIL:
                    send(error(Errors.EXTERNAL_INTERFACE, data));
                    break;
                case END_SESSION:
                    send(error(Errors.SESSION_FAILED, data));
                    break;
            }
        }

        public static function custom(params:Object):void {
            send(params);
        }

        private static function signature():String {
            var data:Object = {
                vtid: config.vtid,
                zoneid: config.zoneId,
                u: config.publisherId,
                runtime: Stats.elapsedTime("ad manager"),
                am_type: Config.APP_NAME
            };

            return ObjectTools.paramString(data);
        }

        private static function event(event:String, eventData:String = null):Object {
            var obj:Object = {
                vpaidEvent: event
            };

            if (eventData) obj['vpaidEventData'] = eventData;

            return obj;
        }

        private static function error(code:Number, data:String):Object {
            var obj:Object = {
                error: code,
                vpaidEventData: data
            };

            return obj;
        }

        private static function send(params:Object):void {
            Console.log("//" + Config.SERVER + "/" + Config.ENDPOINT_LOG + "?" + signature() + "&" + ObjectTools.paramString(params));
            new URLLoader().load(new URLRequest("//" + Config.SERVER + "/" + Config.ENDPOINT_LOG + "?" + signature() + "&" + ObjectTools.paramString(params)));
        }

    }

}