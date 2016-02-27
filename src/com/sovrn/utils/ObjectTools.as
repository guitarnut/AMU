package com.sovrn.utils {

    public class ObjectTools {

        public static function paramString(obj:Object, exclude:Array = []):void {
            var query:Array = [];

            Object.keys(obj).map(function (val:*, index:Number, array:Array) {
                if (obj[val] && exclude.indexOf(exclude) == -1) {
                    query.push(val + " = " + obj[val]);
                }
            });

            return query.join("&");
        }

    }

}