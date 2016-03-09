package com.sovrn.utils {

    public class ObjectTools {

        public static function paramString(obj:Object, exclude:Array = null):String {
            var query:Array = [];
            exclude = exclude || [];

            for(var val:String in obj) {
                if (exclude.indexOf(val) == -1) {
                    query.push(val + "=" + obj[val]);
                }
            }

            return query.join("&");
        }

        public static function paramsToObj(params:String):Object {
            var result:Object = {};
            var pairs:Array = params.split("&");

            pairs.map(function(val:String, index:Number, array:Array):void {
                var pair:Array = val.split("=");

                if(pair.length == 2) {
                    result[pair[0]] = pair[1];
                }
            });

            return result;
        }

        public static function values(obj:Object, exclude:Array = null):String {
            var query:Array = [];
            exclude = exclude || [];

            for(var val:String in obj) {
                if (obj[val] && exclude.indexOf(exclude) == -1) {
                    query.push(val + ": " + obj[val]);
                }
            }

            return query.join(",\n");
        }

    }

}