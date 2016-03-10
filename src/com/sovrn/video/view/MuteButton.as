package com.sovrn.video.view {

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class MuteButton extends Sprite {

        [Bindable]
        [Embed(source="img/ui_unmute.png")]
        private var asset_on:Class;
        private var icon_on:Bitmap;
        [Bindable]
        [Embed(source="img/ui_muted.png")]
        private var asset_off:Class;
        private var icon_off:Bitmap;
        private var muted:Boolean = true;

        public function MuteButton() {
            icon_on = new asset_on() as Bitmap;
            icon_on.smoothing = true;
            icon_on.x = 0;
            icon_on.y = 0;

            addChild(icon_on);

            icon_off = new asset_off() as Bitmap;
            icon_off.smoothing = true;
            icon_off.x = 0;
            icon_off.y = 0;

            buttonMode = true;
            mouseChildren = false;
            addEventListener(MouseEvent.CLICK, toggle);
        }

        public function volume(v:Number):void {
            if(v > 0) {
                muted = false;
            } else {
                muted = true;
            }

            toggle();
        }

        private function toggle(e:MouseEvent = null):void {
            if (e) muted = !muted;
            var remove:Bitmap;

            if (!muted) {
                addChild(icon_on);
                remove =icon_off;
            } else {
                addChild(icon_off);
                remove = icon_on;
            }

            try {
                removeChild(remove);
            } catch (e:Error) {
                //
            }
        }

        public function get isMuted():Boolean {
            return muted;
        }

        public function show():void {
            visible = true;
        }

        public function hide():void {
            visible = false;
        }

    }

}