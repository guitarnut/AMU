package {
    import com.sovrn.ads.AdCall;
    import com.sovrn.ads.AdController;
    import com.sovrn.events.AdManagerEvent;
    import com.sovrn.model.ApplicationModel;
    import com.sovrn.utils.StringTools;
    import com.sovrn.vpaid.VPAIDWrapper;

    import flash.display.Sprite;

    public class Sovrn extends Sprite {

        private var applicationConfig:Object;
        private var vpaid:VPAIDWrapper;
        private var adController:AdController;
        private var adCall:AdCall;
        private var initCalled:Boolean;
        private var adDeliveryCalled:Boolean;

        public function Sovrn() {
            initCalled = false;
            adDeliveryCalled = false;

            adController = new AdController();

            vpaid = new VPAIDWrapper(adController);
            vpaid.addEventListener(AdManagerEvent.INIT_AD_CALLED, serveAds);

            config();
        }

        public function getVPAID():* {
            return vpaid;
        }

        private function config():void {
            var params:Object = this.loaderInfo.parameters;

            var appModelBuilder:ApplicationModel = new ApplicationModel();
            appModelBuilder.setParameters(params);
            appModelBuilder.setPublisherId(params.u);
            appModelBuilder.setPublisherLoc(params.loc);
            appModelBuilder.setVtid(params.vtid);
            appModelBuilder.setZoneId(params.zoneId);
            appModelBuilder.setServer(params.ljt);
            appModelBuilder.setStageWidth(params.vidwidth || this.width || 0);
            appModelBuilder.setStageHeight(params.vidheight || this.height || 0);
            appModelBuilder.setTrueLoc("");
            appModelBuilder.setTrueDomain(StringTools.domain(""));

            applicationConfig = appModelBuilder.build();

            getAds();
        }

        private function getAds():void {
            adCall = new AdCall(applicationConfig);
            adCall.addEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
        }

        private function serveAds(e:AdManagerEvent):void {
            switch (e.type) {
                case AdManagerEvent.AD_DELIVERY_COMPLETE:
                    adCall.removeEventListener(AdManagerEvent.AD_DELIVERY_COMPLETE, serveAds);
                    adController.setAds(e.data.ads);
                    adDeliveryCalled = true;
                    break;
                case AdManagerEvent.INIT_AD_CALLED:
                    initCalled = true;
                    break;
            }

            if (initCalled && adDeliveryCalled) {
                adController.loadAd();
            }
        }

        private function end():void {

        }

    }

}