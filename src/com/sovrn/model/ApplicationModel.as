package com.sovrn.model {

    public class ApplicationModel {

        private static const NAME:String = "Sovrn Ad Manager";
        private static const VERSION:String = "2.0";
        private var parameters:Object;
        private var stageWidth:int;
        private var stageHeight:int;
        private var zoneId:int;
        private var publisherId:String;
        private var publisherLoc:String;
        private var trueLoc:String;
        private var trueDomain:String;
        private var vtid:String;
        private var server:String;

        public function ApplicationModel() {
        }

        public function build():Object {
            var VO:ApplicationVO = new ApplicationVO();

            VO.name = ApplicationModel.NAME;
            VO.version = ApplicationModel.VERSION;
            VO.parameters = this.parameters;
            VO.stageWidth = this.stageWidth;
            VO.stageHeight = this.stageHeight;
            VO.zoneId = this.zoneId;
            VO.publisherId = this.publisherId;
            VO.publisherLoc = this.publisherLoc;
            VO.trueLoc = this.trueLoc;
            VO.trueDomain = this.trueDomain;
            VO.vtid = this.vtid;
            VO.server = this.server;

            return VO;
        }

        public function setParameters(val:Object):void {
            this.parameters = val;
        }

        public function setStageWidth(val:int):void {
            this.stageWidth = val;
        }

        public function setStageHeight(val:int):void {
            this.stageHeight = val;
        }

        public function setZoneId(val:int):void {
            this.zoneId = val;
        }

        public function setPublisherId(val:String):void {
            this.publisherId = val;
        }

        public function setPublisherLoc(val:String):void {
            this.publisherLoc = val;
        }

        public function setTrueLoc(val:String):void {
            this.trueLoc = val;
        }

        public function setTrueDomain(val:String):void {
            this.trueDomain = val;
        }

        public function setVtid(val:String):void {
            this.vtid = val;
        }

        public function setServer(val:String):void {
            this.server = val;
        }

    }

}