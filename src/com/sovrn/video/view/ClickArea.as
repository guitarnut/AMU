package com.sovrn.video.view {

    import com.sovrn.constants.Config;
    import com.sovrn.utils.Console;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    import vpaid.VPAIDEvent;

    public class ClickArea extends Sprite {

        private var target:String;
        private var tracking:Array;

        public function ClickArea(url:String, pixels:Array) {
            target = url;
            tracking = pixels;
            buttonMode = true;
            addEventListener(MouseEvent.CLICK, handleClick);
        }

        public function resize(w:Number, h:Number):void {
            graphics.beginFill(0x000000, 0);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();
        }

        private function handleClick(e:MouseEvent):void {
            e.stopImmediatePropagation();

            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdClickThru));

            removeEventListener(MouseEvent.CLICK, handleClick);
            buttonMode = false;
            navigateToURL(new URLRequest(target), "_blank");

            tracking.map(function (val:String, index:Number, array:Array):void {
                if (index < Config.TRACKING_PIXEL_LIMIT) new URLLoader(new URLRequest(val));
            })
        }

    }

}