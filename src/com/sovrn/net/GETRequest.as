package com.sovrn.net {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class GETRequest extends Sprite implements IRequest {

        private var loader:URLLoader;
        private var uri:String;
        public var data:*;

        public function GETRequest(uri:String) {
            this.uri = uri;
        }

        public function sendRequest():void {
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, complete);
            loader.load(new URLRequest(uri));
        }

        private function complete(e:Event):void {
            data = e.target.data;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function cancel():void {
            loader.removeEventListener(Event.COMPLETE, complete);
            loader.close();
        }

    }

}