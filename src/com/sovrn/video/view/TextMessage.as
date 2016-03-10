package com.sovrn.video.view {

    import flash.display.Sprite;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class TextMessage extends Sprite {

        private var textbox:TextField;
        private var textFormat:TextFormat;

        public function TextMessage() {
            textFormat=new TextFormat();
            textFormat.align = TextFormatAlign.RIGHT;
            textFormat.size = 11;

            textbox = new TextField();
            textbox.defaultTextFormat = textFormat;
            textbox.type = TextFieldType.DYNAMIC;
            textbox.antiAliasType = AntiAliasType.ADVANCED;
            textbox.autoSize = TextFieldAutoSize.LEFT;
            textbox.border = false;
            textbox.selectable = false;
            textbox.textColor = 0xFFFFFF;
            textbox.background = false;

            addChild(textbox);
        }

        public function update(msg:String):void {
            textbox.text = msg;
        }

        public function show():void {
            visible = true;
        }

        public function hide():void {
            visible = false;
        }

    }

}