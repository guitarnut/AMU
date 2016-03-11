package com.sovrn.utils {

    public class StringTools {

        public static function domain(fullPath:String):String {
            var baseDomain:String = fullPath;

            try {
                // grabs base domain, ignores 'http(s)://', 'www', and everything after '/', or '?', or '#'
                var reg:RegExp = /^(?:http?s?:\/\/)?(?:www\.)?([^\/?#]+)?/i;

                // takes everything from '//' to the first '/', splits them by '.'
                baseDomain = fullPath.match(reg)[1];
            } catch (e:Error) {
                //
            }

            return baseDomain;

        }

    }

}