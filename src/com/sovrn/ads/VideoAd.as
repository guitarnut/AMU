package com.sovrn.ads {
    import com.sovrn.constants.AdTypes;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.InitConfigVO;
    import com.sovrn.view.Canvas;

    public class VideoAd implements IAdInstance {

        private static const AD_TYPE:String = AdTypes.VIDEO;
        private var _ad:*;
        private var _data:AdVO;
        private var _config:InitConfigVO;
        private var _view:Canvas;

        public function VideoAd(data:AdVO):void {

        }

        public function load():void {

        }

        public function destroy():void {

        }

        public function set config(initConfig:InitConfigVO):void {
            _config = initConfig;
        }

        public function set view(val:Canvas):void {
            _view = val;
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