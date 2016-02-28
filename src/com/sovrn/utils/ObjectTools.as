package com.sovrn.utils {

    public class ObjectTools {

        public static function paramString(obj:Object, exclude:Array = null):String {
            var query:Array = [];
            exclude = exclude || [];

            for(var val:String in obj) {
                if (obj[val] && exclude.indexOf(exclude) == -1) {
                    query.push(val + "=" + obj[val]);
                }
            }

            return query.join("&");
        }

    }

}