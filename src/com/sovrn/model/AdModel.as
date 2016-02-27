package com.sovrn.ads {

    public class AdModel {

        private var adType:String;
        private var VASTVersion:String;
        private var adSystem:Array;
        private var adTitle:Array;
        private var sovrnImpression:String;
        private var impressions:Array;
        private var errors:Array;
        private var trackingEvents:Object;
        private var duration:String;
        private var adParameters:String;
        private var mediaFile:Object;
        private var tid:String;
        private var campaignId:int;
        private var cb:String;
        private var bannerId:int;
        private var rtb_tid:int;
        private var rtb_pid:int;

        public function AdModel() {
        }

        public function build():Object {
            const VO:Object = {
                AdType: this.adType,
                VASTVersion: this.VASTVersion,
                adSystem: this.adSystem,
                adTitle: this.adTitle,
                sovrnImpression: this.sovrnImpression,
                impressions: this.impressions,
                errors: this.errors,
                trackingEvents: this.trackingEvents,
                duration: this.duration,
                adParameters: this.adParameters,
                mediaFile: this.mediaFile,
                tid: this.tid,
                campaignId: this.campaignId,
                cb: this.cb,
                bannerId: this.bannerId,
                rtb_tid: this.rtb_tid,
                rtb_pid: this.rtb_pid
            };

            return VO;
        }

        public function setAdType(val:String):void {
            this.adType = val;
        }

        public function setVASTVersion(val:String):void {
            this.VASTVersion = val;
        }

        public function setAdSystem(val:Array):void {
            this.adSystem = val;
        }

        public function setAdTitle(val:Array):void {
            this.adTitle = val;
        }

        public function setSovrnImpression(val:String):void {
            this.sovrnImpression = val;
        }

        public function setImpressions(val:Array):void {
            this.impressions = val;
        }

        public function setErrors(val:Array):void {
            this.errors = val;
        }

        public function setTrackingEvents(val:Object):void {
            this.trackingEvents = val;
        }

        public function setDuration(val:String):void {
            this.duration = val;
        }

        public function setAdParameters(val:String):void {
            this.adParameters = val;
        }

        public function setMediaFile(val:Object):void {
            this.mediaFile = val;
        }

        public function setTid(val:String):void {
            this.tid = val;
        }

        public function setCampaignId(val:int):void {
            this.campaignId = val;
        }

        public function setCb(val:String):void {
            this.cb = val;
        }

        public function setBannerId(val:int):void {
            this.bannerId = val;
        }

        public function setRtb_tid(val:int):void {
            this.rtb_tid = val;
        }

        public function setRtb_pid(val:int):void {
            this.rtb_pid = val;
        }
    }

}