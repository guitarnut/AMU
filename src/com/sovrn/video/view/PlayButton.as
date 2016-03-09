package com.sovrn.video.view {

    import flash.display.Bitmap;
    import flash.display.Sprite;

    public class PlayButton extends Sprite {

        [Bindable]
        [Embed(source="img/ui_play.png")]
        private var asset:Class;
        private var icon:Bitmap;

        public function PlayButton() {
            icon = new asset() as Bitmap;
            icon.smoothing = true;
            icon.x = -1 * asset.width / 2;
            icon.y = -1 * asset.height / 2;

            buttonMode = true;
            mouseChildren = false;

            addChild(icon);
        }

    }

}