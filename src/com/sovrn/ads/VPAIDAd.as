package com.sovrn.ads {
    import com.sovrn.constants.AdTypes;

    public class VPAIDAd implements IAdInstance {

        private static const AD_TYPE:String = AdTypes.VPAID;
        private var _ad:*;
        private var _data:Object;

        public function VPAIDAd(data:Object):void {

        }

        public function load():void {

        }

        public function destroy():void {

        }

        public function get ad():* {
            return _ad;
        }

        public function get adType():String {
            return AD_TYPE;
        }

        public function get data():Object {
            return _data;
        }

    }

}