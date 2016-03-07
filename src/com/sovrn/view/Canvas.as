package com.sovrn.view {

    import flash.display.Sprite;

    public class Canvas extends Sprite {

        public function Canvas():void {
            hide();
        }

        public function resize(w:Number = 0, h:Number = 0, color:uint = 0xFF0000):void {
            this.graphics.beginFill(color, 1);
            this.graphics.drawRect(0,0,w,h);
            this.graphics.endFill();
        }

        public function show():void {
            this.visible = true;
        }

        public function hide():void {
            this.visible = false;
        }

    }

}