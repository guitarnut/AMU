package com.sovrn.video.view {

    import flash.display.Bitmap;
    import flash.display.Sprite;

    public class MuteButton extends Sprite {

        [Bindable]
        [Embed(source="img/ui_muted.png")]
        private var asset_on:Class;
        private var icon_on:Bitmap;
        [Bindable]
        [Embed(source="img/ui_unmute.png")]
        private var asset_off:Class;
        private var icon_off:Bitmap;

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
        }

    }

}