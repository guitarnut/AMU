package com.sovrn.view {

    import com.sovrn.utils.Console;

    import flash.display.Sprite;

    public class Canvas extends Sprite {

        private var _width:Number;
        private var _height:Number;

        public function Canvas():void {
            hide();
        }

        public function resize(w:Number = 0, h:Number = 0, color:uint = 0x000000):void {
            this.graphics.beginFill(color, 1);
            this.graphics.drawRect(0, 0, w, h);
            this.graphics.endFill();
            _width = w;
            _height = h;
        }

        public function show():void {
            this.visible = true;
        }

        public function hide():void {
            this.visible = false;
        }

        public function cleanup():void {
            var len:Number = numChildren;
            for (var i:Number = 0; i < len; i++) {
                removeChildAt(0);
            }
        }

        override public function get width():Number {
            return _width;
        }

        override public function get height():Number {
            return _height;
        }

    }

}