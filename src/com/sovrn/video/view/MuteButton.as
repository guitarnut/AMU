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

/*

 [Bindable]
 [Embed(source="img/icon.png")]
 private static var _asset:Class;
 private static var _bitAsset:BitmapAsset;
 private static var _icon:Bitmap;
 private static var _iconContainer:Sprite;
 private static var _onstage:Boolean = false;
 private static var _timer:Timer;
 private static var _x:Number;
 private static var _y:Number;

 public function LoadIcon() {
 }

 public static function start():void {
 if (!_icon) {
 // need this class to export in the build
 _bitAsset = new BitmapAsset();

 _icon = new _asset() as Bitmap;
 _icon.smoothing = true;
 _icon.x = -1 * (_icon.width / 2);
 _icon.y = -1 * (_icon.height / 2);

 _iconContainer = new Sprite();
 _iconContainer.addChild(_icon);

 _timer = new Timer(50, 0);
 _timer.addEventListener(TimerEvent.TIMER, animate);
 }

 */