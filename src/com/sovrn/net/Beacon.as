/**
 * Created by rhenley on 2/11/16.
 */
package com.sovrn.net {

    import com.sovrn.model.ApplicationVO;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.ExternalMethods;
    import com.sovrn.utils.ObjectTools;

    public class Beacon {

        private var config:ApplicationVO;
        private var beaconFired:Boolean = false;

        public function Beacon(data:ApplicationVO) {
            config = data;
        }

        public function fire():void {
            var referrer:String = ExternalMethods.referrer();
            var loc:String = config.trueLoc;
            var equals:RegExp = /=/g;
            var amp:RegExp = /&/g;

            var params:Object = {
                viewID: config.tid,
                rand: Math.floor(Math.random() * 9E3),
                informer: config.zoneId,
                type: "fpads",
                v: "1.2"
            };

            if (referrer != "") {
                var referrerParams:String = getReferrerSearchParams(referrer);
                if (referrerParams != "")  params.lijit_kw = referrerParams;
            }

            var beaconURI:String = "//" + config.server + "/beacon?" + encodeURI(ObjectTools.paramString(params));

            // this must be done after we turn the object into a query string, or referrer and loc params will be sent on the beacon call
            beaconURI += (referrer != "") ? "&rr=" + encodeURI(referrer).replace(amp, "%26").replace(equals, "%3D") : "";
            beaconURI += "&loc=" + encodeURI(loc).replace(amp, "%26").replace(equals, "%3D");

            Console.obj(params);
            Console.log("firing beacon: " + beaconURI);

            ExternalMethods.beacon(beaconURI);

            beaconFired = true;
        }

        private function getReferrerSearchParams(uri:String):String {
            var keys:Array = ['q', 'p', 'search', 'query', 'kw'];
            var paramObjects:Object;
            var paramString:String = "";

            try {
                paramObjects = ObjectTools.paramsToObj(decodeURI(uri.split('?')[1]));

                keys.map(function (val:*, index:int, array:Array):void {
                    if (paramObjects.hasOwnProperty(val)) {
                        paramString += paramObjects[val].replace(/\+/g, ' ').substr(0, 128);
                    }
                });
            } catch (e:Error) {
                //
            }

            return paramString;
        }

        public function get fired():Boolean {
            return beaconFired;
        }

    }
}